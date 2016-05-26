##################Import Modules####################
Import-Module PSReadline

#Import-Module Pscx

##################Define Var####################
$desktop = $env:USERPROFILE + '\desktop'


#echo $PSScriptRoot


#######################Load sub-profiles#######################
& (Join-Path $PSScriptRoot 'DotNetBuildTools\profile.ps1')
& (Join-Path $PSScriptRoot 'SqlServer\profile.ps1')
 