#!/bin/bash

# Pastikan script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
   echo "Script ini harus dijalankan sebagai root!" 
   exit 1
fi

echo "Mengupdate sistem..."
yum update -y

echo "Menginstal dependensi..."
yum groupinstall -y "GNOME Desktop" "Server with GUI"
yum install -y epel-release
yum install -y wget curl policycoreutils-python

echo "Mengunduh Chrome Remote Desktop..."
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_x86_64.rpm -O chrome-remote-desktop.rpm

echo "Menginstal Chrome Remote Desktop..."
yum localinstall -y chrome-remote-desktop.rpm

echo "Mengatur akses Chrome Remote Desktop..."
groupadd chrome-remote-desktop || echo "Group sudah ada"
usermod -aG chrome-remote-desktop $USER

echo "Mengaktifkan GUI default (GNOME)..."
systemctl set-default graphical.target
systemctl isolate graphical.target

echo "Mengaktifkan layanan Chrome Remote Desktop..."
systemctl enable chrome-remote-desktop@$USER.service
systemctl start chrome-remote-desktop@$USER.service

echo "Instalasi selesai. Silakan konfigurasi Chrome Remote Desktop melalui https://remotedesktop.google.com/access"
