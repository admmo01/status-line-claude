[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

$claudeDir = "$env:USERPROFILE\.claude"
$scriptUrl = "https://raw.githubusercontent.com/admmo01/status-line-claude/master/statusline-command.py"
$scriptPath = "$claudeDir\statusline-command.py"
$settingsPath = "$claudeDir\settings.json"

$gitBash = "C:\Program Files\Git\bin"
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
if ($currentPath -notlike "*$gitBash*") {
    Write-Host "=> Ajout de Git Bash au PATH..."
    [System.Environment]::SetEnvironmentVariable("Path", $currentPath + ";$gitBash", "Machine")
    Write-Host "OK Git Bash ajoute au PATH"
} else {
    Write-Host "OK Git Bash deja dans le PATH"
}

if (!(Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
}

Write-Host "=> Telechargement du script statusline..."
Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
Write-Host "OK Script installe"

Write-Host "=> Mise a jour de settings.json..."
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath | ConvertFrom-Json
} else {
    $settings = [PSCustomObject]@{}
}
$settings | Add-Member -NotePropertyName "statusLine" -NotePropertyValue ([PSCustomObject]@{
    type = "command"
    command = "python `"$scriptPath`""
}) -Force
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath
Write-Host "OK settings.json mis a jour"

Write-Host ""
Write-Host "DONE Installation terminee ! Redemarrez Claude Code pour voir la statusline."
