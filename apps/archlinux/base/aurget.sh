#!/bin/bash
set -e
useradd -m pacman | true
sed -i '/pacman ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
echo "pacman ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
cd /tmp
if [ -n "$2" ]
then
    sudo -u pacman gpg --keyserver $2 --recv-keys $3
fi
sudo -u pacman wget https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz
sudo -u pacman tar xfz $1.tar.gz
rm $1.tar.gz
cd $1
sudo -u pacman PKGEXT=.pkg.tar makepkg --syncdeps --noconfirm
mkdir -p /aur
cp $1*.pkg.tar /aur
cd ..
rm -rf $1
userdel -r pacman
sed -i '/pacman ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
