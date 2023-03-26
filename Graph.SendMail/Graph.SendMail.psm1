function Send-GraphMail {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ClientId,

        [Parameter(Mandatory)]
        [string]$ClientSecret,

        [Parameter(Mandatory)]
        [string]$TenantName,

        [Parameter(Mandatory)]
        [string]$From,

        [Parameter(Mandatory)]
        [string[]]$Recipients,

        [Parameter(Mandatory)]
        [string]$Subject,

        [Parameter(Mandatory)]
        [string]$EmailBody
    )

    $ReqTokenBody = @{
        Grant_Type    = "client_credentials"
        Scope         = "https://graph.microsoft.com/.default"
        Client_Id     = $ClientId
        Client_Secret = $ClientSecret
    } 

    $TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

    $RecipientBlock = ""
    foreach ($Recipient in $Recipients) {
        $Block = @"
        {
            "EmailAddress": {
                "Address": "$Recipient"
            }
        },
"@
        $RecipientBlock = $RecipientBlock + $Block
    }

    $apiUrl = "https://graph.microsoft.com/v1.0/users/$From/sendMail"
    $body = @"
    {
        "Message": {
            "Subject": "$Subject",
            "Body": {
                "ContentType": "HTML",
                "Content": "$EmailBody"
            },
            "ToRecipients": [
                $RecipientBlock
            ]
        },
        "SaveToSentItems": "false",
        "isDraft": "false"
    }
"@

    try {
        $call = Invoke-RestMethod -Headers @{Authorization = "Bearer $($TokenResponse.access_token)"} -Uri $apiUrl -Body $Body -Method Post -ContentType 'application/json'
    } catch {
        Write-Error "Error sending email: $_"
    }
}
