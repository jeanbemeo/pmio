#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
    echo "Silakan jalankan sebagai root."
    exit 1
fi

# Update sistem

# Instal xrdp dan TigerVNC Server
echo "Menginstal xrdp dan TigerVNC Server..."
yum install -y xrdp tigervnc-server

# Enable dan start layanan xrdp
echo "Mengaktifkan layanan xrdp..."
systemctl enable xrdp
systemctl start xrdp

# Konfigurasi SELinux untuk xrdp
echo "Mengonfigurasi SELinux..."
semanage port -a -t rdp_port_t -p tcp 5901 || true
semanage permissive -a xrdp_t || true

# Konfigurasi firewall untuk RDP dan VNC
echo "Mengonfigurasi firewall..."
firewall-cmd --permanent --add-port=5901/tcp
firewall-cmd --permanent --add-service=vnc-server
firewall-cmd --reload

# Konfigurasi VNC untuk user
echo "Konfigurasi VNC untuk user..."
read -p "Masukkan username untuk VNC: " username
if id "$username" &>/dev/null; then
    mkdir -p /home/"$username"/.vnc
    vncpasswd -f <<< "password" > /home/"$username"/.vnc/passwd
    chmod 600 /home/"$username"/.vnc/passwd
    chown -R "$username:$username" /home/"$username"/.vnc

    echo -e "[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
User=$username
WorkingDirectory=/home/$username
ExecStart=/usr/bin/vncserver :1
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/vncserver@:1.service

    systemctl daemon-reload
    systemctl enable vncserver@:1
    systemctl start vncserver@:1
else
    echo "User $username tidak ditemukan. Pastikan user sudah dibuat."
fi

echo "Proses selesai. Anda dapat menggunakan RDP dengan IP server di port 3389 atau VNC di port 5901."
