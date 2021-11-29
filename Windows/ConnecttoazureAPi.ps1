$ClientID       = "<your client ID here>"        # Should be a ~36 hex character string; insert your info here
$ClientSecret   = "<your client secret here>"    # Should be a ~44 character string; insert your info here
$tenantdomain   = "<your tenant domain here>"    # For example, contoso.onmicrosoft.com

$loginURL       = "https://login.microsoft.com"
$resource       = "https://graph.microsoft.com"

$body       = @{grant_type="client_credentials";resource=$resource;client_id=$ClientID;client_secret=$ClientSecret}
$oauth      = Invoke-RestMethod -Method Post -Uri $loginURL/$tenantdomain/oauth2/token?api-version=1.0 -Body $body

Write-Output $oauth

if ($oauth.access_token -ne $null) {
        $headerParams = @{'Authorization'="$($oauth.token_type) $($oauth.access_token)"}

        $url = "https://graph.microsoft.com/beta/identityRiskEvents"
        Write-Output $url

        $myReport = (Invoke-WebRequest -UseBasicParsing -Headers $headerParams -Uri $url)

        foreach ($event in ($myReport.Content | ConvertFrom-Json).value) {
            Write-Output $event
        }

} else {
        Write-Host "ERROR: No Access Token"
}