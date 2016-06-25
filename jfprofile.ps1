# TODO: remove/redefine default iex cmdlet alias to use Elixir
# (Get-Host).UI.RawUI.BackgroundColor = "darkblue"
# Clear-Host
New-Alias lsb Get-ChildItemBare
function Get-ChildItemBare { Get-ChildItem -Name }

Rename-Item Alias:iex inx -Force

function Prompt
{
	$wd = " " + (Get-Location).Path.Replace( $HOME, '~' )  # does 'Get-Location.Path' not work?
    Write-Host "PS" -NoNewline -ForegroundColor DarkGreen
    Write-Host ($wd + ">") -NoNewline -ForegroundColor Green
    return " "
}
