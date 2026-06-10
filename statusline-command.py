import json, sys, os, subprocess, time

sys.stdout.reconfigure(encoding="utf-8")

ESC = "\033"

def clr(r, g, b):
    return f"{ESC}[38;2;{r};{g};{b}m"

RESET = f"{ESC}[0m"
YELLOW = f"{ESC}[33m"
RED = f"{ESC}[31m"
GREEN = clr(76, 175, 80)
MODEL_COLOR = clr(210, 170, 90)
CTX_BLUE = clr(129, 140, 248)

def build_bar(pct, width=10):
    filled = int(pct * width / 100)
    empty = width - filled
    return '█' * filled + '░' * empty

data = json.load(sys.stdin)

cwd = (data.get("workspace") or {}).get("current_dir") or data.get("cwd") or ""
m = data.get("model") or {}
model = m.get("display_name") or m.get("id") or "Claude"
cw = data.get("context_window") or {}
pct = cw.get("used_percentage")
effort_obj = data.get("effort") or {}
effort = effort_obj.get("level") or ""
rl = data.get("rate_limits") or {}
five_h = (rl.get("five_hour") or {}).get("used_percentage")
five_h_reset = (rl.get("five_hour") or {}).get("resets_at")
seven_d = (rl.get("seven_day") or {}).get("used_percentage")

folder = os.path.basename(cwd)
branch = ""
try:
    branch = subprocess.check_output(
        ["git", "--git-dir", os.path.join(cwd, ".git"), "--work-tree", cwd, "symbolic-ref", "--short", "HEAD"],
        stderr=subprocess.DEVNULL
    ).decode().strip()
except:
    try:
        branch = subprocess.check_output(
            ["git", "--git-dir", os.path.join(cwd, ".git"), "--work-tree", cwd, "rev-parse", "--short", "HEAD"],
            stderr=subprocess.DEVNULL
        ).decode().strip()
    except:
        pass

parts = []

if folder:
    parts.append(f"/{folder}")
if branch:
    parts.append(f"({branch})")

if model:
    if effort:
        parts.append(f"{MODEL_COLOR}{model}{RESET} [{effort}]")
    else:
        parts.append(f"{MODEL_COLOR}{model}{RESET}")

if pct is not None:
    pct_int = round(pct)
    bar = build_bar(pct_int)
    if pct_int > 70:
        ctx_color = RED
    elif pct_int > 40:
        ctx_color = YELLOW
    else:
        ctx_color = CTX_BLUE
    parts.append(f"{ctx_color}ctx [{bar}] {pct_int}%{RESET}")

if five_h is not None:
    five_int = round(five_h)
    bar = build_bar(five_int)
    if five_int <= 40:
        color = GREEN
    elif five_int <= 70:
        color = YELLOW
    else:
        color = RED
    countdown = ""
    if five_h_reset:
        diff = int(five_h_reset) - int(time.time())
        if diff > 0:
            h, rem = divmod(diff, 3600)
            mn = rem // 60
            countdown = f" Reset in {h}h{mn}m" if h > 0 else f" Reset in {mn}m"
    parts.append(f"· 5h {color}[{bar}] {five_int}%{RESET}{countdown}")

if seven_d is not None:
    seven_int = round(seven_d)
    if seven_int >= 30:
        bar = build_bar(seven_int)
        if seven_int <= 40:
            color = GREEN
        elif seven_int <= 70:
            color = YELLOW
        else:
            color = RED
        parts.append(f"7d {color}[{bar}] {seven_int}%{RESET}")

print(" | ".join(parts), end="")
