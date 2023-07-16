#!/bin/sh

dotfiles="https://github.com/awtGerry/dotfiles.git"
programs="https://raw.githubusercontent.com/awtGerry/install-aw/master/programs.csv"
# programs="programs.csv" # for testing purposes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m"

echo -e "Instalador para sistemas basados en Arch linux"
echo -e "--- Para que la instalacion sea correcta el programa necesita permisos root"

# TODO: Checar si existe el usuario y si no crearlo
echo -e "${NC}> Ingrese nombre de usuario: ${BLUE}\c"
read username
echo -e "${NC}> Ingresa contraseña de $username: \c"
read -s password
echo -e ""

function error() {
    printf "${RED}%s${NC}\n" "$1" >&2;
    exit 1;
}

function install_default_programs() {
    for app in base-devel curl git gcc; do
        echo -e "${BLUE}Instalando $app" || error "No se pudo instalar $app"
        pacman -S --noconfirm --needed $app >/dev/null 2>&1 || error "No se pudo instalar $app"
    done
}

function install_aur_helper() {
    echo -e "${NC}El programa necesita un ayudante AUR, si ya tienes uno instalado puedes omitir la siguiente parte presionando enter."
    echo ""
    aur_helper="null"
    while [[ ! "$aur_helper" =~ ^(yay|paru|no|"")$ ]]; do
        echo -e "> Instalar ayudante AUR? [yay/paru]: ${BLUE}\c${NC}"
        read aur_helper
        case $aur_helper in
            [yay]* ) aur="yay" install_aur || error "No se pudo instalar yay";;
            [paru]* ) aur="paru" install_aur || error "No se pudo instalar paru";;
            [no]*|"") check_aur_installation || error "No se encontro ayudante AUR" ;;
            * ) exit "Opcion invalida";;
        esac
    done
}

function install_aur() {
    echo -e "${NC}Instalando $aur..."
    sudo -u "$username" git clone -q https://aur.archlinux.org/"$aur".git
    cd "$aur"
    sudo -u "$username" makepkg -si --noconfirm --needed >/dev/null 2>&1
    cd .. && rm -rf "$aur"
    echo -e "${GREEN}"$aur" fue instalado correctamente!${NC}"
}

function check_aur_installation() {
    if command -v yay &> /dev/null; then
        aur="yay"
    elif command -v paru &> /dev/null; then
        aur="paru"
    else
        error "No se encontro ayudante AUR"
    fi
    echo -e "${GREEN}"$aur" sera utilizado para continuar la instalacion${NC}"
}

function install_dotfiles() {
    cd /home/"$username"
    echo -e "${NC}Instalando dotfiles..."
    sudo -u "$username" git clone -q --recursive "$dotfiles"
    cd dotfiles
    sudo -u "$username" cp -rf .config .local /home/"$username"/Documents
    echo -e "${GREEN}Configuracion de dotfiles instalada correctamente${NC}"
}

function install_all_programs() {
    ([ -f "$programs" ] && cp "$programs" /tmp/programs.csv) || curl -Ls "$programs" | sed '/^#/d' > /tmp/programs.csv
    total=$(wc -l < /tmp/programs.csv)
    echo -e "${BLUE}Instalando programas, puedes relajarte y tomar un cafe mientras :)${NC}"
    pacman -Syy >/dev/null 2>&1 || error "Error: checar conexion a internet"
    while IFS=, read -r name description; do
        n=$((n+1))
        echo -e "${BLUE}Instalando $name ($n/$total): $description"
        sudo -u "$username" "$aur" -S --noconfirm --needed "$name" >/dev/null 2>&1 || error "No se pudo instalar $name"
    done < /tmp/programs.csv ;
}

function clean_home() {
    cd /home/$username
    rm -rf dotfiles
}

install_default_programs || error "Error al instalar, checar conexion a internet."
install_aur_helper || error "No se pudo instalar el aur_helper"
install_dotfiles || error "No se pudo instalar los dotfiles"
install_all_programs || error "Ha ocurrido un error instalando los programas."
clean_home || error "Error al limpiar /home/$username"

echo -e "${GREEN}Instalacion finalizada!"
