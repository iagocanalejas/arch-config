# Configuration script for Arch Linux
```sh
./autoconf.sh
```


## Steps
- Configure mirrors and pacman.
  ```sh
    sudo pacman -S --noconfirm pacman-contrib curl git reflector rsync
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    #Add parallel downloading
    sudo sed -i 's/^#Para/Para/' /etc/pacman.conf

    #Enable multilib
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Sy --noconfirm
  ```
- Installs `Yay`.
  ```sh
    cd ~/.local/share
    git clone "https://aur.archlinux.org/yay.git" yay
    cd yay
    makepkg -si --noconfirm
    cd $SCRIPT_DIR
  ```
- Installs `asdf`.
  ```sh
    cd ~/.local/share
    git clone https://aur.archlinux.org/asdf-vm.git 
    cd asdf-vm 
    makepkg -si --noconfirm
    cd $SCRIPT_DIR
  ```
- Removes unwanted apps.
- Installs `yay` and `pacman` apps.
- Change default programs and configurations.

## Next Steps

### Copy .ssh keys
```sh
sudo chmod 755 ~/.ssh
sudo chmod 600 ~/.ssh/*
sudo chmod 644 ~/.ssh/*.pub
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 644 ~/.ssh/config
``` 