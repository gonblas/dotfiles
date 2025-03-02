import os
import subprocess
import argparse

# Colores ANSI
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
NC = "\033[0m"  # Reset color

def run_command(command):
    try:
        subprocess.run(command, check=True, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except subprocess.CalledProcessError as e:
        return False
    return True

def check_packages_exist(package_list, package_manager):
    valid_packages = []
    for package in package_list:
        result = subprocess.run(f"{package_manager} -Sp {package} --noconfirm", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode == 0:
            valid_packages.append(package)
        else:
            print(f"{YELLOW}Package {package} does not exist in repositories.{NC}")
    return valid_packages

def read_programs(file_path):
    programs = {'pacman': [], 'aur': [], 'pip': [], 'git': []}
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('#') or not line.strip():
                continue
            tag, program = line.strip().split(',')
            match tag:
                case 'p':
                    programs['pacman'].append(program)
                case 'a':
                    programs['aur'].append(program)
                case 'i':
                    programs['pip'].append(program)
                case 'g':
                    programs['git'].append(program)
    return programs

def install_package(package, package_manager):
    command_map = {
        'pacman': f'sudo pacman --noconfirm --needed -S {package}',
        'pip': f'sudo pacman --noconfirm --needed -S {package}',
        'aur': f'sudo -u {username} {aurhelper} -S --noconfirm {package}',
    }
    
    if not run_command(command_map[package_manager]):
        print(f"{RED}Failed to install package: {package}{NC}")
    else:
        print(f"{GREEN}Successfully installed: {package}{NC}")

def install_packages(package_list, package_manager):
    if package_list:
        group_size = 10
        for i in range(0, len(package_list), group_size):
            group = package_list[i:i+group_size]
            packages = ' '.join(group)
            command_map = {
                'pacman': f'sudo pacman --noconfirm --needed -S {packages}',
                'pip': f'sudo pacman --noconfirm --needed -S {packages}',
                'aur': f'sudo -u {username} {aurhelper} -S --noconfirm {packages}',
            }
            print(f"{GREEN}Installing programs ({package_manager}): {packages}{NC}")
            if not run_command(command_map[package_manager]):
                for package in group:
                    install_package(package, package_manager)

def main():
    global username, aurhelper, command_map

    parser = argparse.ArgumentParser(description="Automate Archlinux configuration setup")
    parser.add_argument("--username", required=True, help="Username for the installation")
    parser.add_argument("--aurhelper", default="paru", help="AUR helper to use (default: paru)")
    parser.add_argument("--progsfile", default="~/progs.csv", help="Path to the programs file")
    args = parser.parse_args()

    username = args.username
    aurhelper = args.aurhelper
    progsfile = os.path.expanduser(args.progsfile)
    
    print(f"{GREEN}Reading package list from {progsfile}...{NC}")
    packages = read_programs(progsfile)
    
    print(f"{GREEN}Checking available packages...{NC}")
    packages['pacman'] = check_packages_exist(packages['pacman'], 'pacman')
    install_packages(packages['pacman'], 'pacman')
    install_packages(packages['aur'], 'aur')
    install_packages(packages['pip'], 'pip')

    print(f"{GREEN}Installation process completed successfully!{NC}")

if __name__ == "__main__":
    main()
