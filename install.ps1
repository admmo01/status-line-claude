[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
# Claude Status Line - Windows Installer
# https://github.com/admmo01/status-line-claude

$claudeDir = "$env:USERPROFILE\.claude"
$scriptUrl = "https://raw.githubusercontent.com/admmo01/status-line-claude/master/statusline-command.py"
$scriptPath = "$claudeDir\statusline-command.py"
$settingsPath = "$claudeDir\settings.json"

# 1. Ajouter Git Bash au PATH si pas déjà présent
$gitBash = "C:\Program Files\Git\bin"
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
if ($currentPath -notlike "*$gitBash*") {
    Write-Host "→ Ajout de Git Bash au PATH..."
    [System.Environment]::SetEnvironmentVariable("Path", $currentPath + ";$gitBash", "Machine")
    Write-Host "✓ Git Bash ajouté au PATH"
} else {
    Write-Host "✓ Git Bash déjà dans le PATH"
}

# 2. Créer le dossier .claude si nécessaire
if (!(Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
}

# 3. Télécharger le script Python
Write-Host "→ Téléchargement du script statusline..."
Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
Write-Host "✓ Script → $scriptPath"

# 4. Mettre à jour settings.json
Write-Host "→ Mise à jour de settings.json..."
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath | ConvertFrom-Json
} else {
    $settings = @{}
}
$settings | Add-Member -NotePropertyName "statusLine" -NotePropertyValue @{
    type = "command"
    command = "python `"$scriptPath`""
} -Force
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath
Write-Host "✓ settings.json mis à jour"

Write-Host ""
Write-Host "✅ Installation terminée ! Redémarre Claude Code pour voir la statusline."
