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

# $body = $(Get-Module -ListAvailable | Select-Object Name, Path) #"This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

$inputNB = "SimplePosh.ipynb"
$sourceNB = "https://raw.githubusercontent.com/MsSQLGirl/jubilant-data-wizards/main/Simple%20Demo/PowerShell%20Notebooks/SimpleAdditionInPowerShell.ipynb"
Invoke-WebRequest $sourceNB -OutFile $inputNB
$test = Invoke-ExecuteNotebook $inputNB

$body = "Hello, $test. This HTTP triggered function executed successfully."


if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body 
})
