using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# # Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$alpha = $Request.Query.alpha
if (-not $alpha) {
    $alpha = $Request.Body.alpha
}

$ratio = $Request.Query.ratio
if (-not $ratio) {
    $ratio = $Request.Body.ratio
}

$a = $Request.Query.a
if (-not $ratio) {
    $a = $Request.Body.a
}

# Below is to test if the module gets installed automatically.
# $body = $(Get-Module -ListAvailable | Select-Object Name, Path) #"This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

# Below is to run Julie's simple Posh script
# $sourceNB = "https://raw.githubusercontent.com/MsSQLGirl/jubilant-data-wizards/main/Simple%20Demo/PowerShell%20Notebooks/SimpleAdditionInPowerShell.ipynb"


##################################
# ### Test Powershell Notebook ###
##################################

# # Below is Doug's input.ipynb file
$sourceNB = "https://raw.githubusercontent.com/dfinke/PowerShellNotebook/master/input.ipynb"

# # One can call the raw path directly and then just substitute paramters with the input request
$body = Invoke-ExecuteNotebook $sourceNB -Parameters @{ alpha=$alpha; ratio=$ratio; a=$a}

# # print it out here
# $body = $test # "Hello, $test. This HTTP triggered function executed successfully."

# # this doesn't work because local path not supported
# Invoke-WebRequest $sourceNB -OutFile $inputNB
# $test = Invoke-ExecuteNotebook $inputNB

# if name is provided then don't do the notebook thingy
if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body 
})
