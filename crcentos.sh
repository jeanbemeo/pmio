#!/bin/bash

# Pastikan script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
   echo "Script ini harus dijalankan sebagai root!" 
   exit 1
fi

# Meminta nama pengguna
read -p "Masukkan nama pengguna untuk Chrome Remote Desktop: " USERNAME

# Memastikan pengguna ada
if ! id "$USERNAME" &>/dev/null; then
    echo "Pengguna $USERNAME tidak ditemukan. Pastikan pengguna telah dibuat sebelumnya."
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

echo "Mengatur akses Chrome Remote Desktop untuk $USERNAME..."
groupadd chrome-remote-desktop || echo "Group sudah ada"
usermod -aG chrome-remote-desktop "$USERNAME"

echo "Mengaktifkan GUI default (GNOME)..."
systemctl set-default graphical.target
systemctl isolate graphical.target

echo "Membuat layanan Chrome Remote Desktop untuk $USERNAME..."
LOGINCTL_STATUS=$(loginctl show-user "$USERNAME" 2>/dev/null)

if [[ -z "$LOGINCTL_STATUS" ]]; then
    echo "Layanan systemd user-session tidak aktif. Pastikan Anda login ke pengguna $USERNAME sebelum memulai layanan."
    echo "Layanan belum diaktifkan. Instalasi selesai."
else
    su - "$USERNAME" -c "systemctl --user enable chrome-remote-desktop.service"
    su - "$USERNAME" -c "systemctl --user start chrome-remote-desktop.service"
    echo "Layanan Chrome Remote Desktop untuk $USERNAME telah diaktifkan."
fi

echo "Instalasi selesai. Silakan konfigurasi Chrome Remote Desktop melalui https://remotedesktop.google.com/access"
