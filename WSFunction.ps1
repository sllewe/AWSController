using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

if ($name -contains 'status') {
Set-AWSCredentials -AccessKey  xxxxx -SecretKey $Key -StoreAs AWSProfile
Initialize-AWSDefaultConfiguration -ProfileName AWSProfile -Region us-east-1
    $body = Get-WKSWorkspace -workspaceid $WSID | select-object State
}


if ($name -contains 'stop') {

    $body = Start-WKSWorkspace -workspaceid $WSID | select-object State
    Stop-WKSWorkspace -workspaceid $WSID 
start-sleep -seconds 5
$body=  Get-WKSWorkspace -workspaceid $WSID | select-object State
}

if ($name -contains 'start') {
Set-AWSCredentials -AccessKey  xxxx -SecretKey $Key -StoreAs AWSProfile

Start-WKSWorkspace -workspaceid $WSID
start-sleep -seconds 5
$body=  Get-WKSWorkspace -workspaceid ws-9qjjbsmdn | select-object State

}


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
