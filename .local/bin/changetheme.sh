#!/bin/env bash

# Themes avaible
tokyo="󰨶   Tokyonight"
nord="󱡂   Nord"
catppuccin="   Catppuccin"
gruvbox="   Gruvbox"

# Get answer from user via rofi
selected_option=$(echo "$tokyo
$nord
$catppuccin
$gruvbox" | rofi -dmenu -i -p "Themes" \
  -l 4 \
  -mesg "T H E M E S")

alacritty_dir="$HOME/.config/alacritty/"
qtile_dir="$HOME/.config/qtile"
nvim_config_file="$HOME/.config/nvim/init.lua"
tmux_dir="$HOME/.config/tmux"
wallpaper_dir="$HOME/.local/wallpapers"
rofi_dir="$HOME/.config/rofi"
rofi_themes="$HOME/.local/share/rofi/themes"

# $1 theme name
# $2 vim colorscheme
# $3 wallpaper
change() {
  sed -i "s/^colors\s*=\s*\(.*\)/colors = $1/" "$HOME/.config/qtile/settings/pallete.py"
  sed -i 's/^vim.cmd \[\[colorscheme\s*\(.*\)/vim.cmd [[colorscheme '"$2"']]/' "$nvim_config_file"
  if [ -e $tmux_dir ]; then
    cp -f "$tmux_dir/themes/$1.conf" "$tmux_dir/tmux.conf"
    tmux source "$tmux_dir/tmux.conf"
  fi
  if [ -e $alacritty_dir ]; then
    cp -f "$alacritty_dir/themes/$1.yml" "$alacritty_dir/alacritty.yml"
  fi
  if [ -f "$wallpaper_dir/$3" ]; then
    feh --bg-scale "$wallpaper_dir/$3"
    sed -i 's/^feh\s*\(.*\)/feh --bg-scale \$HOME\/.local\/wallpapers\/'"$3"'/' "$qtile_dir/autostart.sh"
  fi
  if [ -f "$rofi_themes/$1.rasi" ]; then
    sed -i 's/^@theme\s*\(.*\)/@theme \"'"$1"'\"/' "$rofi_dir/config.rasi"
    sed -i 's/^@theme\s*\(.*\)/@theme \"'"$1"'\"/' "$rofi_dir/powermenu.rasi"
  fi
  qtile cmd-obj -o cmd -f restart
}

# Do something based on selected option
case "$selected_option" in
  "$tokyo")
    change "tokyonight" "tokyonight-night" "2.jpg"
    ;;
  "$nord")
    change "nord" "nord" "nord.png"
    ;;
  "$catppuccin")
    change "catppuccin" "catppuccin-mocha" "catppuccin.png"
    ;;
  "$gruvbox")
    change "gruvbox" "gruvbox" "gruvbox.png"
    ;;
  *)
    echo No match
    ;;
esac
