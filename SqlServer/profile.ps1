
Set-Alias -Name sql -Value Invoke-SqlCmd -Scope Global
echo "sql -> Invoke-SqlCmd"

. (Join-Path $PSScriptRoot 'Get-dbTableColumns.ps1')