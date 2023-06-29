<div align="center">
    <h1><strong>AwesomeWM dotfiles</strong></h1>
    <img title="screenshot" alt="system" src="./screenshot.png">
</div>

# Programas
Todos los programas y dependencias en [programs.csv](./programs.csv)

## AUR Helper
Para archlinux es necesario tener paru o yay a la mano.
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
En algunos casos esto no sirve ya que instala `x` driver, entonces
mejor buscar los drivers de tu tarjeta en [la pagina de nvidia](https://www.nvidia.com/download/index.aspx).
En mi caso los drivers son los 470
```sh
paru -S nvidia-470xx-dkms nvidia-470xx-utils opencl-nvidia-470xx
```

Reiniciar y el comando `nvidia-smi` debera mostrar un output

Finalmente agregar las lineas siguientes a `/usr/share/sddm/scripts/Xsetup`
```sh
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
```

## Neovim
### Packer
```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
