#!/bin/bash

set -e

# Check if the OS is macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ This script is meant to run on macOS. Aborting..."
    exit 1
fi

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo "✅ Docker is already installed."

    # Check if jq is installed (for version comparison)
    if ! command -v jq &> /dev/null; then
        echo "❌ jq is not installed. Installing jq..."
        brew install jq
    fi

    # Check if Docker is up-to-date
    current_version=$(docker --version | awk '{print $3}' | sed 's/,//')
    latest_version=$(curl -s https://api.github.com/repos/docker/desktop/releases/latest | jq -r .tag_name)

    if [[ "$current_version" == "$latest_version" ]]; then
        echo "Docker is already up-to-date ($current_version). No need to install."
        exit 0
    else
        echo "An older version of Docker is installed. Upgrading..."
    fi
else
    echo "❌ Docker is not installed. Installing Docker..."
fi

echo "🚀 Installing Docker Desktop for macOS..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew is already installed."
fi

# Install Docker using Homebrew
brew install --cask docker

# Open Docker Desktop app
echo "🔄 Opening Docker Desktop..."
open -a Docker

# Give a few seconds for Docker to start
sleep 10

# Verify installation
echo "✅ Docker installed successfully!"
docker --version
docker compose version

# Reminder to start Docker manually the first time
echo "💡 Docker Desktop will need to be manually started the first time you run it. Make sure it's running!"
