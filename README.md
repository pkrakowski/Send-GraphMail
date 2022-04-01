# Send-GraphMail

PowerShell module which allows daemons to send notification emails in a more secure way by using Microsoft's Graph API and Modern Authentication.

## Prerequisites 

1. Register new application in Azure AD under 'App Registrations'

2. Assign it Send.Mail Application permission and create a new Client Secret.

3. Scope permissions to select mailboxes as per below.

https://docs.microsoft.com/en-us/graph/auth-limit-mailbox-access

Note: For additional security recently added support for Conditional Access for Workload Identities (Preview) can be implemented.

https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/workload-identity


## Example usage 
```
Import-Module Graph.SendMail

Send-GraphMail -From "notifications@mycompany.com" `
-Recipients "anna@example.com", "tom@example.com" `
-Subject "Test subject" `
-EmailBody "This is a test email" `
-clientId  `
-clientSecret `
-TenantName
```
