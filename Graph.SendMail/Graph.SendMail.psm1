function Send-GraphMail {
  [CmdletBinding()]
  param (

    [Parameter(Mandatory)]
    [string]$clientId,
    
    [Parameter(Mandatory)]
    [string]$clientSecret,

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
  client_Id     = $clientID
  Client_Secret = $clientSecret
} 

$TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

foreach ($Recipient in $Recipients){
  $Block = "
{
  `"EmailAddress`": {
    `"Address`": `"$Recipient`"
  }
},"
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

$call = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $apiUrl -Body $Body -Method Post -ContentType 'application/json'
}
