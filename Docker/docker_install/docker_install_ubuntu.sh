#!/bin/bash

set -e

# Check if the OS is Ubuntu
if [[ "$(lsb_release -si)" != "Ubuntu" ]]; then
    echo "❌ This script is meant to run on Ubuntu. Aborting..."
    exit 1
fi

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo "✅ Docker is already installed."

    # Check if jq is installed (for version comparison)
    if ! command -v jq &> /dev/null; then
        echo "❌ jq is not installed. Installing jq..."
        sudo apt-get install -y jq
    fi

    # Check if Docker is up-to-date
    current_version=$(docker --version | awk '{print $3}' | sed 's/,//')
    latest_version=$(curl -s https://api.github.com/repos/docker/docker-ce/releases/latest | jq -r .tag_name)

    if [[ "$current_version" == "$latest_version" ]]; then
        echo "Docker is already up-to-date ($current_version). No need to install."
        exit 0
    else
        echo "An older version of Docker is installed. Upgrading..."
    fi
else
    echo "❌ Docker is not installed. Installing Docker..."
fi

echo "🛠️  Installing Docker..."

# Uninstall old versions
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

# Install required packages
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repo
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine, CLI, containerd, Compose plugin
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group (so you can run without sudo)
sudo usermod -aG docker $USER

echo "✅ Docker installed successfully."
echo "🔁 Log out and log back in OR run 'newgrp docker' to use Docker without sudo."
docker --version
docker compose version
