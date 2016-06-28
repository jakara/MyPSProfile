##################Import Modules####################
if ((Get-Module PSReadLine | measure).Count -eq 0)
{
    Import-Module 'C:\Program Files\WindowsPowerShell\Modules\PSReadline\1.1\PSReadLine.psm1'
}
else{
    Import-Module PSReadline
}

#Import-Module Pscx

##################Define Var####################
$desktop = $env:USERPROFILE + '\desktop'

############################Set-Alias#############################
set-alias open explorer.exe #pretty like start -> Start-Process
#########################Define functions############################

function reloadProfile () {
    clear
    Push-Location
    . $profile
    Pop-Location
    echo "profile reloaded:$profile"
}

#######################Load sub-profiles#######################
. (Join-Path $PSScriptRoot 'DotNetBuildTools\profile.ps1')
. (Join-Path $PSScriptRoot 'SqlServer\profile.ps1')
 