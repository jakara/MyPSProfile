##################Import Modules####################
if ((Get-Module PSReadLine | Measure-Object).Count -eq 0) {
    Import-Module 'C:\Program Files\WindowsPowerShell\Modules\PSReadline\1.1\PSReadLine.psm1'
}
else {
    Import-Module PSReadline
}

#Import-Module Pscx

#load oh-my-posh theme
Set-Theme Agnoster

##################Define Var####################
$desktop = $env:USERPROFILE + '\desktop'
$path = $env:Path.split(";")

############################Set-Alias#############################
set-alias open explorer.exe #pretty like start -> Start-Process
#########################Define functions############################



#######################Load sub-profiles#######################
. (Join-Path $PSScriptRoot 'Common\profile.ps1')
. (Join-Path $PSScriptRoot 'DotNetBuildTools\profile.ps1')
. (Join-Path $PSScriptRoot 'SqlServer\profile.ps1')
. (Join-Path $PSScriptRoot 'Office\profile.ps1')
. (Join-Path $PSScriptRoot 'Windows\profile.ps1')
