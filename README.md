# AWESOME WM archivos
# Programas
Todos los programas y dependencias en [programs.csv](./programs.csv)

## AUR Helper
Para arch/artix necesario tener paru o yay a la mano.
```sh
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```
## NVIDIA drivers
Para nuevas tarjetas (o no tan viejas) solo es instalar:
```sh
sudo pacman -S nvidia nvidia-utils opencl-nvidia
```
Pero para tener el mejor "rendimiento" mejor instalar la version
del ultimo driver que nos dice su [pagina](https://google.com/).
En mi caso los drivers son los 470
```sh
paru -S nvidia-470xx-dkms nvidia-470xx-utils opencl-nvidia-470xx
```
Reiniciar y el comando `nvidia-smi` debera mostrar un output

### Graficos integrados y GPU
TODO

## Neovim
### Packer
```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
