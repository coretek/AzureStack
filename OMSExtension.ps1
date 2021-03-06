If (!(Test-Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory | Out-Null
    }
     
Elseif{
$source = "https://opsinsight.blob.core.windows.net/publicfiles/MMASetup-AMD64.exe"

$destination = Join-Path -Path $env:TEMP -ChildPath "MMASetup-AMD64.exe"

Invoke-WebRequest $source -OutFile $destination

copy-Item -Path "$env:TEMP\MMASetup-AMD64.exe" -Destination "C:\Temp"

$workspaceID= "81471d22-7961-497e-abdf-15b585fb8902"

$workspaceKey= "78U/hiUk4+TAOI2GwFwlAviifBB8FfyAowBrVp74blM6aK2y5I8qO+6CdDiEJi8pQptspW8edQW85RNdkCawCQ=="
$omspath = "C:\Temp"
$installstring = $omspath +'\MMASetup-AMD64.exe /C:"setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 '+  "OPINSIGHTS_WORKSPACE_ID=$workspaceID " + "OPINSIGHTS_WORKSPACE_KEY=$workspaceKey " +'AcceptEndUserLicenseAgreement=1"'
CMD.exe /C $installstring


$healthServiceSettings = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
`.EnableAzureOperationalInsights('workspacename', 'workspacekey')
.ReloadConfiguration()
	}
