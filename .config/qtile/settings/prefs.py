import os

mod="mod1"
alt="mod1"
terminal="alacritty"
browser="brave"
private="librewolf"
discord="discord"
file_manager="thunar"
code_editor="code"
launcher="rofi -show drun"
screenshot="scrot --select --line mode=edge '/tmp/%F_%T_$wx$h.png' -e 'xclip -selection clipboard -target image/png -i $f && rm $f'"
full_screenshot="scrot '/tmp/%F_%T_$wx$h.png'"
pdf_viewer="zathura"
spotify="spotify"
obsidian="obsidian"
vscode="code"
power_menu=os.path.expanduser("~/.local/bin/powermenu.sh")
change_theme=os.path.expanduser("~/.local/bin/changetheme.sh")
