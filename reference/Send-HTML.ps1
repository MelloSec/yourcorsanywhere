function Send-OutlookMessage
<#
    .SYNOPSIS
    Sends mail message using Outlook REST API

    .DESCRIPTION
    Sends mail using Outlook REST API using the account of given credentials. 
    Message MUST be html (or plaintext).

    
    .Example
    PS C:\>$At=Get-AADIntAccessTokenForEXO
    PS C:\>Send-AADIntOutlookMessage -AccessToken $At -Recipient someone@company.com -Subject "An email" -Message "This is a message!"
   
#>
{
    Param(
        [Parameter(Mandatory=$False)]
        [String]$AccessToken,
        [Parameter(Mandatory=$True)]
        [String]$Recipient,
        [Parameter(Mandatory=$True)]
        [String]$Subject,
        [Parameter(Mandatory=$True)]
        [String]$Message,
        [Parameter(Mandatory=$False)]
        [Switch]$SaveToSentItems
    )

    Process
    {
        # Get from cache if not provided
        $AccessToken = Get-AccessTokenFromCache -AccessToken $AccessToken -Resource "https://outlook.office365.com" -ClientId "d3590ed6-52b3-4102-aeff-aad2292ab01c"
    
        $Request=@"
        {
          "Message": {
            "Subject": $(Escape-StringToJson $Subject),
            "Body": {
                "ContentType": "HTML",
                "Content": $(Escape-StringToJson $Message)
            },
            "ToRecipients": [
              {
                "EmailAddress": {
                  "Address": "$Recipient"
                }
              }
            ]
          },
          "SaveToSentItems": "$(if($SaveToSentItems){"true"}else{"false"})"
        }
"@

        $Cmd="me/sendmail"

        # Convert to UTF-8 bytes
        $Request_bytes = [system.Text.Encoding]::UTF8.getBytes($Request)

        Call-OutlookAPI -AccessToken $AccessToken -Command $Cmd -Method Post -Request $Request_bytes
    }
}

Send-OutlookMessage -AccessToken $AccessToken -Recipient $Recipient -Subject $Subject -MessageFilePath $MessageFilePath -SaveToSentItems
