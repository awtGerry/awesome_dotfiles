#!/bin/sh

dotfiles="https://github.com/awtGerry/dotfiles.git"
programs="https://raw.githubusercontent.com/awtGerry/install-aw/master/programs.csv"

echo -e "Instalador para sistemas basados en Arch linux"
echo -e "--- Para que la instalacion sea correcta el programa necesita permisos root"

# TODO: Checar si existe el usuario y si no crearlo
echo -e "> Ingrese nombre de usuario: \c"
read username
echo -e "> Ingresa contraseña de $username: \c"
read -s password
echo -e ""

function error() {
    printf "%s\n" "$1" >&2;
    exit 1;
}

function install_default_programs() {
    for app in base-devel curl git gcc; do
        pacman -Sq --noconfirm --needed $app || error "No se pudo instalar $app"
    done
}

function install_aur_helper() {
    read -p "> Instalar yay o paru como aur_helper? [yay/paru] " aur_helper
    while [[ ! "$aur_helper" =~ ^(yay|paru)$ ]]; do
        case $aur_helper in
            [yay]* ) install_yay || error "No se pudo instalar yay" aur="yay";;
            [paru]* ) install_paru || error "No se pudo instalar paru" aur="paru";;
            * ) exit "Opcion invalida";;
        esac
    done
}

function install_yay() {
    sudo -u "$username" git clone https://aur.archlinux.org/yay.git
    cd yay
    sudo -u "$username" makepkg -si
    cd .. && rm -rf yay
    echo -e "yay fue instalado correctamente"
}

function install_paru() {
    sudo -u "$username" git clone https://aur.archlinux.org/paru.git
    cd paru
    sudo -u "$username" makepkg -si
    cd .. && rm -rf paru
    echo -e "paru fue instalado correctamente"
}

function install_dotfiles() {
    cd /home/"$username"
    echo -e "Clonando dotfiles..."
    sudo -u "$username" git clone -q --recursive "$dotfiles"
    cd dotfiles
    mv .config .local /home/"$username"/Downloads # TODO: No sobreescribir archivos
    echo -e "Configuracion de dotfiles instalada correctamente"
}

function install_all_programs() {
    ([ -f "$programs" ] && cp "$programs" /tmp/programs.csv) || curl -Ls "$programs" | sed '/^#/d' > /tmp/programs.csv
    total=$(wc -l < /tmp/programs.csv)
    pacman -Syy
    while IFS=, read -r name description; do
        n=$((n+1))
        # echo "$description" | grep -q "^\".*\"$" && description="$(echo "$description" | sed -E "s/(^\"|\"$)//g")"
        echo -e "Instalando $name ($n/$total): $description"
        "$aur" -S --noconfirm --needed --quiet "$name" || error "No se pudo instalar $name"
    done < /tmp/programs.csv ;
}

function clean_home() {
    cd /home/$username
    rm -rf .git .gitignore .gitmodules README.md screenshot.png .config/nvim/.git .config/nvim/.gitignore
}

install_default_programs || error "Error al instalar, checar conexion a internet?"
# install_aur_helper || error "No se pudo instalar el aur_helper"
install_dotfiles || error "No se pudo instalar los dotfiles"
install_all_programs || error "Ha ocurrido un error instalando los programas"
# clean_home || error "Error al limpiar /home/$username"

echo -e "Instalacion finalizada!"
