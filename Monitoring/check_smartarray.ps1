####
#
# NAME:		check_smartarray.ps1
#
# AUTHOR:	Christophe Robert - christophe °dot° robert °at° cocoche °dot° fr
#
# DESC:		Check Hpacucli results for RAID status on Windows - hpacucli command line tool
#
#			Script compatibility : Python 2+
#			Return Values :
#				No problems - OK (exit code 0)
#				Drive status != OK but not "Failed" - WARNING (exit code 1)
#				Drive status is "Failed" - CRITICAL (exit code 2)
#
#				TODO : Script errors - UNKNOWN (exit code 3)
#
# VERSION:	1.0 - Initial dev. - 09-02-2012 (02 Sept. 2012)
#		1.1 - Correcting some errors and add comments - 09-15-2013 (15 Sept. 2013)
#			* Add SAS array to be considerated (only SATA was before)
#			* Add comments
#			* Add UNKNOWN mark - script errors 
#		1.2 - Correcting some errors - 09-24-2013 (24 Sept. 2013)
#			* Add SCSI array to be considerated
#			* Add comments
#		1.3 - Add multi controllers compatibility - 01-07-2015 (07 Jan. 2015)
#		1.4 - Add controller, battery and cache status checks - 01-18-2015 (18 Jan. 2015)
#		1.5 - Modify result analisys - 01-21-2015 (21 Jan. 2015)
#
####

Function Read-HPSmartArrayStatus ($buffer){
	#creation de table de hash qui permet d'associer une clé et une valeur
	$system = @{"ctrl" = @() ; "array" = @() ; "logical" = @() ; "physical" = @()}

	foreach ($line in $buffer)
	{
		$line = $line.trim()
		# Insert all controllers in dedicated list of dict
		if ($line -like "Smart Array*")
		{
			#Write-Host "--Debug-- Enter smart"
			#Write-Host "--Debug-- Value = $line"
			$system.Item("ctrl") += $line
			#$system.Item("ctrl").add($line)
			#Write-Host "--Debug-- Dict : $system"
		}
				
		# Insert all arrays in dedicated list of dict
		elseif ($line -like "*array*SATA*" -Or $line -like "*array*SAS*" -Or $line -like "*array*SCSI*")
		{
			#Write-Host "--Debug-- Enter array"
			#Write-Host "--Debug-- Value = $line"
			$system.Item("array") += $line
			#$system.Item("array").add($line)
			#Write-Host "--Debug-- Dict : $system"
		}
			
		# Insert all logicaldrives in dedicated list of dict
		elseif ($line -like "*logicaldrive*")
		{
			#Write-Host "--Debug-- Enter logical"
			#Write-Host "--Debug-- Value = $line"
			$system.Item("logical") += $line
			#$system.Item("logical").add($line)
			#Write-Host "--Debug-- Dict : $system"
		}
		
		# Insert all physicaldives in dedicated list of dict
		elseif ($line -like "*physicaldrive*")
		{
			#Write-Host "--Debug-- Enter physical"
			#Write-Host "--Debug-- Value = $line"
			$system.Item("physical") += $line
			#$system.Item("physical").add($line)
			#Write-Host "--Debug-- Dict : $system"
		}
	}
		
	#Write-Host "--Debug-- Show 'system' dict content"
	#Write-Host "--Debug-- Value = $system"
	
	return $system
}


Function Get-Errors ($buffer){

	$errors = @{"CRITICAL" = @() ; "WARNING" = @() ; "UNKNOWN" = @()}
	$nb_ctrl = 0
	$nb_array = 0
	$nb_logical = 0
	$nb_physical = 0
	
	# For each controller found, check errors and find S/N
	foreach ($element in $buffer.Item("ctrl"))
	{
		#Write-Host "--Debug-- Controller : $element"
		$nb_ctrl += 1

		$slot = $element.split(" ")[5]
		#Write-Host "--Debug-- Slot : $slot"
        
        $ctrl_status = & $prg "ctrl slot=$slot show status"
		
		$ctrl_status = $ctrl_status | Where-Object { $_ }

		foreach ($line in $ctrl_status)
		{
			#Write-Host "--Debug-- Controller internal status : $line"
            if ($line -like "Smart*")
            {
                $hw = $line.trim()
            }
			if ($line -like "*Status*")
			{
				if ($line -notlike "*OK*")
                {
                    $status = $line.trim()
                    $errors.Item("WARNING") += "$status in $hw"
                }
			}
		}
	}

	# For each array found, check errors
	foreach ($element in $buffer.Item("array"))
	{
		#Write-Host "--Debug-- Array : $element"
		$nb_array += 1
	}
			
	# For each logicaldrive found, check errors
	foreach ($element in $buffer.Item("logical"))
	{
		#Write-Host "--Debug-- Logicaldrive : $element"
		$nb_logical += 1
			
		if ($element -like "*OK*")
		{
			#Write-Host $element
			continue
		}
		elseif ($element -like "*Failed*")
		{
			#Write-Host $element
			$errors.Item("CRITICAL") += $element
		}
		elseif ($element -like "*Recover*")
		{
			#Write-Host $element
			$errors.Item("WARNING") += $element
		}
		else
		{
			#Write-Host $element
			$errors.Item("UNKNOWN") += $element
		}
	}
			
	# For each logicaldrive found, check errors
	foreach ($element in $buffer.Item("physical"))
	{				
		#Write-Host "--Debug-- Physicaldrive : $element"
		$nb_physical += 1
		
		if ($element -like "*OK*")
		{
			#Write-Host $element
			continue
		}
		elseif ($element -like "*Failed*")
		{
			#Write-Host $element
			$errors.Item("CRITICAL") += $element
		}
		elseif ($element -like "*Rebuilding*")
		{
			#Write-Host $element
			$errors.Item("WARNING") += $element
		}
		else
		{
			#Write-Host $element
			$errors.Item("UNKNOWN") += $element
		}
	}
		
	#Write-Host "--Debug-- Errors dict : $errors"
	return $errors, $nb_ctrl, $nb_array, $nb_logical, $nb_physical
}
	

### Core ###

$prg = 'C:\Program Files (x86)\Compaq\Hpacucli\Bin\hpacucli.exe'

$exec = & $prg 'ctrl all show config'
#Write-Host $exec

$global:Warning = 0
$global:Critical = 0
$global:Unknown = 0
$global:ToSend = ""

try
{
	# Execute Hp program with needed parameters and remove empty lines
	$res = $exec | Where-Object { $_ }
	#Write-Host $res

	# Parse and analyse returned lines
	$nagios = Read-HPSmartArrayStatus $res
	#Write-Host $nagios

	# Check errors
	$health, $nb_ctrl, $nb_array, $nb_logical, $nb_physical = Get-Errors $nagios

	#Write-Host "--Debug-- Health dict : $health"
	
	if ($health.Item("CRITICAL").count -ne 0)
	{
		#Write-Host "--Debug-- Enter critical"
		$global:Critical += 1
		foreach ($elem in $health.Item("CRITICAL"))
		{
			$global:ToSend += 'CRITICAL - ' + $health.Item("CRITICAL")
		}
	}
	elseif (($health.Item("WARNING").count -ne 0) -and ($global:Critical -eq 0))
	{
		#Write-Host "--Debug-- Enter warning"
		$global:Warning += 1
		foreach ($elem in $health.Item("WARNING"))
		{
			$global:ToSend += 'WARNING - ' + $health.Item("WARNING")
		}
	}
	elseif (($health.Item("UNKNOWN").count -ne 0) -and ($global:Critical -eq 0) -and ($global:Warning -eq 0))
	{
		#Write-Host "--Debug-- Enter unknown"
		$global:Unknown += 1
		foreach ($elem in $health.Item("UNKNOWN"))
		{
			$global:ToSend += 'UNKNOWN - ' + $health.Item("UNKNOWN")
		}
	}
	elseif (($nb_ctrl -eq 0) -and ($nb_array -eq 0) -and ($nb_logical -eq 0) -and ($nb_physical -eq 0))
	{
		#Write-Host "--Debug-- Enter unknown"
		$global:Unknown += 1
		$global:ToSend += 'UNKNOWN - One of element of these : controller ($nb_ctrl), array ($nb_array), logicaldrive ($nb_logical) or physicaldrive ($nb_physical) is missing !'
	}
	else
	{
		$global:ToSend = "OK - RAID status is good - Nb Ctrl : $nb_ctrl - Nb Array : $nb_array - Nb logicaldrive : $nb_logical - Nb physicaldrive : $nb_physical"
	}

	$global:ToSend = $global:ToSend
	#Write-Host $global:ToSend
}
catch
{
	$global:ToSend = Exception.Message
}
finally
{
	if ($global:Critical -ne 0)
	{
		Write-Host $global:ToSend
		exit 2
	}
	elseif ($global:Warning -ne 0)
	{
		Write-Host $global:ToSend
		exit 1
	}
	elseif ($global:Unknown -ne 0)
	{
		Write-Host $global:ToSend
		exit 3
	}
	else
	{
		Write-Host $global:ToSend
		exit 0
	}
}
