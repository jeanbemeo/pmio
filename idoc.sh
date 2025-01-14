#!/bin/bash

# Perbarui sistem
echo "Memperbarui sistem..."
sudo yum update -y

# Hapus versi Docker lama jika ada
echo "Menghapus versi Docker lama (jika ada)..."
sudo yum remove -y docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-engine

# Tambahkan repositori Docker
echo "Menambahkan repositori Docker..."
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Instal Docker
echo "Menginstal Docker..."
sudo yum install -y docker-ce docker-ce-cli containerd.io

# Aktifkan dan mulai layanan Docker
echo "Mengaktifkan dan memulai layanan Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Verifikasi instalasi Docker
echo "Verifikasi instalasi Docker..."
docker --version

# Tambahkan pengguna ke grup Docker (opsional)
echo "Menambahkan pengguna ke grup Docker..."
sudo usermod -aG docker $(whoami)

echo "Instalasi Docker selesai! Logout dan login kembali untuk menerapkan perubahan grup Docker."
