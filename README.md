# status-line-claude

Status line pour Claude Code sur Windows — affiche le dossier, la branche git, le modèle, le contexte et les rate limits avec des barres de progression colorées.

## Résultat
/mon-projet | (main) | Opus 4.8 (1M context) [high] | ctx [░░░░░░░░░░] 3% | · 5h [█░░░░░░░░░] 14% Reset in 1h3m
## Prérequis

- Windows 10/11
- [Git for Windows](https://git-scm.com/download/win) installé
- [Python 3.x](https://www.python.org/downloads/) installé avec **"Add to PATH"** coché
- Claude Code installé

## Installation

Dans **PowerShell en admin** :

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/admmo01/status-line-claude/master/install.ps1" -OutFile "$env:TEMP\install.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\install.ps1"
```

Redémarre Claude Code. C'est tout.

## Ce que ça affiche

| Segment | Description |
|---|---|
| `/dossier` | Dossier du projet |
| `(branch)` | Branche git |
| Modèle | Nom du modèle + niveau d'effort |
| `ctx` | Utilisation du contexte (bleu → jaune → rouge) |
| `5h` | Rate limit 5h avec countdown |
| `7d` | Rate limit 7j (affiché seulement au-dessus de 30%) |

## Désinstallation

1. Supprimer le fichier `C:\Users\<username>\.claude\statusline-command.py`
2. Supprimer le bloc `statusLine` dans `C:\Users\<username>\.claude\settings.json`
3. Redémarrer Claude Code
