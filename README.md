# Send-GraphMail

Send-GraphMail is a PowerShell module designed to provide a secure and reliable method for daemons to send notification emails. By leveraging Microsoft's Graph API and Modern Authentication, it offers enhanced security compared to traditional SMTP authentication.

## Prerequisites

To use this PowerShell function, you need to create an Azure App Registration and configure the appropriate permissions for the Microsoft Graph API. Follow these steps:

1. Sign in to the [Azure portal](https://portal.azure.com/).
2. Navigate to **Azure Active Directory**.
3. Go to **App registrations** and click on the **New registration** button.
4. Enter a name for your app, and choose the **Accounts in this organizational directory only** option for **Supported account types**. Click **Register**.
5. After registration, you will be redirected to the **Overview** page for your new app. Note down the **Application (client) ID** and **Directory (tenant) ID** as you will need them later.
6. Go to **Certificates & secrets** under **Manage** in the left-hand menu. Click **New client secret** and provide a description and expiration for the secret. Click **Add**. Note down the **Value** of the newly created client secret, as you will need it later. Be sure to copy the secret value now, as you won't be able to see it again.
7. Go to **API permissions** under **Manage** in the left-hand menu. Click **Add a permission**, then choose **Microsoft Graph** as the API you want to use.
8. Select **Application permissions** and search for the **Mail.Send** permission in the **Select permissions** search box. Expand the **Mail** section and check the box next to **Mail.Send**. Click **Add permissions**.
9. Click on **Grant admin consent for [Your Organization]** to grant the necessary permissions for the app. Confirm the action when prompted. This step requires administrator privileges for your Azure Active Directory.

Optionally, you can scope the permissions to only select mailboxes by following [these instructions](https://docs.microsoft.com/en-us/graph/auth-limit-mailbox-access).

Also, consider limiting access with Conditional Access for Workload Identities using [this guide](https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/workload-identity).

## Example Usage

```powershell
# Import the Send-GraphMail function (assuming it's in the same directory)
Import-Module .\Graph.SendMail.psm1

# Define the required parameters
$ClientId = "your_client_id"
$ClientSecret = "your_client_secret"
$TenantName = "your_tenant_id"
$From = "from@example.com"
$Recipients = @("recipient1@example.com", "recipient2@example.com")
$Subject = "Hello from PowerShell!"
$EmailBody = @"
<p>Dear Recipient,</p>
<p>This is a test email sent using the Send-GraphMail PowerShell function.</p>
<p>Best regards,<br>Sender</p>
"@

# Call the Send-GraphMail function with the defined parameters
Send-GraphMail -ClientId $ClientId -ClientSecret $ClientSecret -TenantName $TenantName -From $From -Recipients $Recipients -Subject $Subject -EmailBody $EmailBody
