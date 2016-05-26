
Set-Alias -Name sql -Value Invoke-SqlCmd
echo "sql -> Invoke-SqlCmd"

& (Join-Path $PSScriptRoot 'Get-dbTableColumns.ps1')