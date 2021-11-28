#!/bin/bash

SCRIPT_DIR=$(pwd)

echo "-------------------------------------------------"
echo "Update pacman keys (WTF: needed this in the laptop)"
echo "-------------------------------------------------"
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys

echo "-------------------------------------------------"
echo "Update pacman"
echo "-------------------------------------------------"
sudo pacman -Suyu --noconfirm

echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"
sudo pacman -S --noconfirm pacman-contrib curl git reflector rsync

#Add parallel downloading
sudo sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sudo pacman -Sy --noconfirm

echo "-------------------------------------------------"
echo "Update again pacman"
echo "-------------------------------------------------"
sudo pacman -Suyu --noconfirm

echo "-------------------------------------------------"
echo "Uninstalling packages"
echo "-------------------------------------------------"
sudo pacman -Rsn --noconfirm - < packages/uninstall.txt

echo "-------------------------------------------------"
echo "Installing YaY"
echo "-------------------------------------------------"
cd ~/.local/share
git clone "https://aur.archlinux.org/yay.git" yay
cd yay
makepkg -si --noconfirm
cd $SCRIPT_DIR

echo "-------------------------------------------------"
echo "Installing pacman packages"
echo "-------------------------------------------------"
sudo pacman -Sy --noconfirm - < packages/pkglist.txt

echo "-------------------------------------------------"
echo "Installing YaY packages"
echo "-------------------------------------------------"
yay -Sy --noconfirm - < packages/yaylist.txt

echo "-------------------------------------------------"
echo "Installing asdf"
echo "-------------------------------------------------"
cd ~/.local/share
git clone https://aur.archlinux.org/asdf-vm.git 
cd asdf-vm 
makepkg -si --noconfirm
cd $SCRIPT_DIR

echo "-------------------------------------------------"
echo "Copy Zsh configuration"
echo "-------------------------------------------------"
cp $SCRIPT_DIR/config/.zshrc $HOME/.zshrc
mkdir -p $HOME/.zsh_functions
touch $HOME/.zsh_history

chsh -s $(which zsh)

echo "-------------------------------------------------"
echo "Copy configurations"
echo "-------------------------------------------------"
\cp -r .config/* $HOME/.config
mkdir ~/Workspace

# Change swappiness
su root -c 'echo "vm.swappiness=10" > /etc/sysctl.d/100-archlinux.conf'

# Enable fstrim
sudo systemctl enable fstrim.timer

echo "-------------------------------------------------"
echo "Installing asdf plugins"
echo "-------------------------------------------------"
/opt/asdf-vm/bin/asdf plugin-add python https://github.com/danhper/asdf-python.git
/opt/asdf-vm/bin/asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
/opt/asdf-vm/bin/asdf install python latest
/opt/asdf-vm/bin/asdf install nodejs latest

echo "-------------------------------------------------"
echo "Update pacman yet again"
echo "-------------------------------------------------"
sudo pacman -Suyu --noconfirm
yay -Suyu --noconfirm

if lspci | grep -E "NVIDIA|GeForce"; then
    echo "-------------------------------------------------"
    echo "Installing nvidia"
    echo "-------------------------------------------------"
	sudo nvidia-xconfig
fi

echo "-------------------------------------------------"
echo "Following programs needs to be manually installed"
echo "-------------------------------------------------"
echo $(<packages/manual-install.txt)