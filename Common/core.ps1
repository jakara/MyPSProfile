#pip install thefuck
#pip install thefuck --upgrade
$env:PYTHONIOENCODING = 'utf-8' # found this solution at https://github.com/nvbn/thefuck/issues/514
Invoke-Expression "$(thefuck --alias)"
Write-Output "common -> fuck"

#boot to zsh

function zsh { C:\WINDOWS\system32\bash.exe -c zsh }#写全路径， 防止在某些软件的集成终端中调用失败

Write-Output "common -> zsh"

#bitshift
function bitshift {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$x,
        [Parameter(ParameterSetName = 'Left')]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Left,
        [Parameter(ParameterSetName = 'Right')]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Right
    )
    $shift = if ($PSCmdlet.ParameterSetName -eq 'Left') {
        $Left
    }
    else {
        - $Right
    }
    return [math]::Floor($x * [math]::Pow(2, $shift))
}
Write-Output "common -> bitshift"

function reloadProfile () {
    Clear-Host
    Push-Location
    . $profile
    Pop-Location
    Write-Output "profile reloaded:$profile"
}
Write-Output "common -> reloadProfile"