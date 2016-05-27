
. (Join-Path $PSScriptRoot 'Invoke-MSBuild.ps1')

. (Join-Path $PSScriptRoot 'Start-BuildingVSSolution.ps1')

 Invoke-MsBuild -Path  "D:\Code\DotNet\Framework\Src\TuJia.Framework.sln" -MsBuildParameters "/target:Clean;Build /property:Configuration=Release;Platform=""Mixed Platforms""" 