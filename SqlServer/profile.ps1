
Set-Alias -Name tsql -Value Invoke-SqlCmd -Scope Global
Write-Output "tsql -> Invoke-SqlCmd"

. (Join-Path $PSScriptRoot 'Get-dbTableColumns.ps1')