#!/bin/sh

# Inspired by Ramiro Cabral repository: https://github.com/ramirocabral/dotfiles

### VARIABLES ###

aurhelper="paru"
script_dir=$(dirname "$(readlink -f "$0")")

### COLORES ###
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # Sin color

### FUNCTIONS ###

error() {
  # Imprime error en rojo y sale con fallo
  echo -e "${RED}ERROR: $1${NC}"
  exit 1
}

success() {
  # Mensajes de éxito en verde
  echo -e "${GREEN}$1${NC}"
}

warning() {
  # Mensajes de advertencia en amarillo
  echo -e "${YELLOW}WARNING: $1${NC}"
}

welcome_msj() {
  # Confirmación antes de la instalación
  echo -e "${GREEN}##### Welcome to my dotfiles install script! #####${NC}"
  echo -n " Are you running this as the root user and have an internet connection? (Y/n): "
  read -r option
  option=${option:-y}

  [[ $option == [Yy] ]] || error "The user exited"
}

usercheck() {
  # Verifica el nombre de usuario
  echo -n "Enter username: "
  read -r name
  id "$name" >/dev/null 2>&1 || error "Invalid username!"
  mkdir -p "/home/$name/.local/src"
  export homedir="/home/$name"
  export repodir="/home/$name/.local/src"
}

copy_progs_csv() {
  echo -e "${GREEN}##### Copying progs.csv file... #####${NC}"
  
  if [ ! -f "$script_dir/progs.csv" ]; then
    error "progs.csv does not exist in the current directory"
  else
    if cmp -s "$script_dir/progs.csv" "$homedir/progs.csv"; then
      success "progs.csv is already identical, no need to copy."
    else
      cp -f "$script_dir/progs.csv" "$homedir/" || error "Failed to copy progs.csv"
      success "progs.csv copied successfully."
    fi
  fi
}

install_aur() {
  sudo -u "$name" mkdir -p "$repodir/$1"
  sudo -u "$name" git -C "$repodir" clone --depth 1 --no-tags -q "https://aur.archlinux.org/$1.git" "$repodir/$1"
  cd "$repodir/$1" || return 1
  sudo -u "$name" makepkg --noconfirm -si "$repodir/$1" >/dev/null 2>&1 || return 1
}

installpkg() {
  pacman --noconfirm --needed -S "$1" >/dev/null 2>&1 || warning "Error installing $1 (PACMAN)"
}

aurinstall() {
  echo "$aurinstalled" | grep -q "^$1$" && return 1
  sudo -u "$name" $aurhelper -S --noconfirm "$1" >/dev/null 2>&1 || warning "Failed installing $1 (AUR)"
}

gitinstall() {
  progname="${1##*/}"
  echo "$gitinstalled" | grep -q "^$progname$" && return 1
  progname="${progname%.git}"
  dir="$repodir/$progname"
  sudo -u "$name" git -C "$repodir" clone --depth 1 --single-branch \
    --no-tags -q "$1" "$dir" ||
    {
      cd "$dir" || warning "Failed installing $1 (GIT)"
      sudo -u "$name" git pull --force origin master
    }
  cd "$dir" || return 1
}

### SCRIPT ###

welcome_msj
usercheck
copy_progs_csv

echo -e "${GREEN}##### Installing all dependencies #####${NC}"

for x in sudo zsh base-devel ca-certificates python python-pip; do
  installpkg "$x"
done

[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers 

trap 'rm -f /etc/sudoers.d/larbs-temp' HUP INT QUIT TERM PWR EXIT 
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/larbs-temp  

echo -e "${GREEN}##### Installing AUR Helper #####${NC}"
sudo chmod -R 777 "$repodir"
install_aur "${aurhelper}" || error "Failed to install AUR helper"

progsfile="$script_dir/progs.csv"
[[ -f "$progsfile" ]] || error "Program file doesn't exist"

python "$script_dir"/.local/bin/package_installer.py --username "$name" --aurhelper "$aurhelper" --progsfile "$progsfile"

echo -e "${GREEN}##### Installing Vencord #####${NC}"
sudo -u "$name" sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"

cd "$script_dir"
stow --adopt .

chsh -s /bin/zsh "$name" >/dev/null 2>&1
sudo -u "$name" mkdir -p "/home/$name/.cache/zsh/"

echo -e "${GREEN}##### Enabling ly.service #####${NC}"
sudo systemctl enable ly.service
sudo systemctl start ly.service

echo -e "${GREEN}##### Enabling brightness in polybar${NC}"
sudo chown $USER:video /sys/class/backlight/intel_backlight/brightness


echo -e "${GREEN}##### Setting timezone #####${NC}"
timedatectl set-timezone America/Argentina/Buenos_Aires

echo -e "${GREEN}##### Setting Cronie #####${NC}"
sudo systemctl enable cronie.service --now
crontab ~/.config/crontab/cronfile

echo -e "${GREEN}DONE! Now reboot your computer${NC}"
