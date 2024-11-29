#!/usr/bin/env bash
#
# Python Installer Script for 3.x.x
# ---------------------------------
# Quickly build and install Python on your system.
#
# Copyright (c) 2021 itheo.tech
# Licensed under the MIT License. See the LICENSE file in the repository for details.
#
# Usage:
#   sudo bash python.sh 3.11.0
# Or directly from GitHub:
#   wget -qO - https://raw.githubusercontent.com/tvdsluijs/sh-python-installer/main/python.sh | sudo bash -s 3.11.0
#
# More info: https://itheo.tech
# Resume: https://theovandersluijs.eu
# Donate: https://donorbox.org/tvdsluijs-github
# Contact: https://itheo.tech/contact
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
###########################

set -euo pipefail

install_python() {
    new_version="$1"
    verbose="${2:-}"

    # Enable verbose mode if -v is passed
    if [[ "$verbose" == "-v" ]]; then
        exec > >(tee "python_install_${new_version}.log") 2>&1
        set -x
    fi

    py_main_version=$(echo "$new_version" | sed '/[.].*[.].*/s/[.][^.]*$//')
    file="Python-${new_version}.tar.xz"
    url="https://www.python.org/ftp/python/${new_version}/${file}"

    # Pre-flight checks
    available_space=$(df / | tail -1 | awk '{print $4}')
    available_space_mb=$((available_space / 1024))
    if (( available_space_mb < 1000 )); then
        echo "❌ Not enough disk space! You have ${available_space_mb}MB available. Please ensure at least 1GB."
        echo "   Exiting in 5 seconds..."
        sleep 5
        exit 1
    fi

    if [[ $EUID -ne 0 ]]; then
        echo "❌ This script must be run as root. Please use 'sudo'."
        echo "   Exiting in 5 seconds..."
        sleep 5
        exit 2
    fi

    # Cleanup function to ensure temporary files are removed
    cleanup() {
        echo "Cleaning up temporary files..."
        rm -rf "Python-${new_version}" "${file}"
    }
    trap cleanup EXIT

    # Display the introductory message
    clear
    echo "##############################################"
    echo "# Welcome to the Python 🐍 Installer Script! #"
    echo "##############################################"
    echo ""
    echo "You are about to install Python version ${new_version}."
    echo "This process will update your system and may take a while,"
    echo "depending on the updates needed and the installation time."
    echo ""
    echo "So grab a cup of coffee ☕ and let this script handle the heavy lifting!"
    echo ""
    echo "💡 Tip: Add '-v' for verbose mode to see detailed logs."
    echo ""
    echo "Press any key to continue..."
    read -r -n1 -t 10 < /dev/tty # Wait for 10 seconds for user input
    if [[ $? -ne 0 ]]; then
        echo "No input provided. Proceeding..."
    fi

    # Dynamically check Python version, prioritizing python3
    if [[ $(command -v python3) ]]; then
        old_version=$(python3 -c 'import platform; print(platform.python_version())')
    elif [[ $(command -v python) ]]; then
        old_version=$(python -c 'import platform; print(platform.python_version())')
    else
        old_version="0"
    fi

    if [ "$(printf '%s\n' "$new_version" "$old_version" | sort -V | head -n1)" = "$new_version" ]; then
        clear
        echo "###############################################"
        echo "#            🚫 Installation Stopped          #"
        echo "###############################################"
        echo ""
        echo "❌ You are attempting to install Python version ${new_version},"
        echo "   which is older than your current version (${old_version})."
        echo ""
        echo "⚠️  Downgrading Python is not recommended as it may cause issues"
        echo "   with existing scripts and dependencies."
        echo ""
        echo "💡 Tip: If you really need to install an older version, consider"
        echo "   using a virtual environment or container to isolate it."
        echo ""
        echo "Exiting this script now to prevent potential conflicts."
        echo "###############################################"
        exit 0
    fi

    clear
    echo "###############################################"
    echo "#           Current Python Version            #"
    echo "###############################################"
    echo ""
    echo "📌 Your current Python version is: ${old_version}"
    echo ""
    echo "⚠️  This script will now update and upgrade your system."
    echo "   This may take some time depending on the updates required."
    echo ""
    echo "Do you want to proceed? (Y/N)"
    read -r user_confirmation < /dev/tty
    if [[ ! "$user_confirmation" =~ ^[Yy]$ ]]; then
        echo ""
        echo "✅ You chose not to proceed. Exiting the script."
        echo "   No changes have been made to your system."
        echo "###############################################"
        exit 0
    fi

    clear
    echo ""
    echo "##############################################"
    echo "#       Updating & upgrading system          #"
    echo "##############################################"
    apt -qq update && apt -y --allow-change-held-packages upgrade < /dev/null || { echo "❌ System update failed! Exiting."; exit 3; }

    clear
    echo ""
    echo "###############################################"
    echo "#       Installing system essentials          #"
    echo "###############################################"
    if ! apt -qq install -y wget build-essential checkinstall < /dev/null; then
        echo "Warning: 'checkinstall' package not available. Proceeding without it."
        apt -qq install -y wget build-essential < /dev/null || { echo "❌ Failed to install system essentials! Exiting."; exit 4; }
    fi

    clear
    echo ""
    echo "###############################################"
    echo "#       Installing Python essentials          #"
    echo "###############################################"
    apt -qq install -y build-essential zlib1g-dev uuid-dev liblzma-dev lzma-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev < /dev/null || { echo "❌ Failed to install Python essentials! Exiting."; exit 5; }

    clear
    echo ""
    echo "###############################################"
    echo "#     Downloading Python ${new_version}       #"
    echo "###############################################"

    # Check if the URL is valid
    if ! wget --spider -q "${url}"; then
        echo "❌ Python version ${new_version} is not available at ${url}."
        echo "   Please verify the version number and try again."
        echo "   Exiting in 5 seconds..."
        sleep 5
        exit 1
    fi

    # Proceed with downloading the file
    if ! wget "${url}"; then
        echo "❌ Failed to download Python source from ${url}. Exiting."
        exit 6
    fi

    clear
    echo ""
    echo "###############################################"
    echo "#             Decompressing file              #"
    echo "###############################################"
    tar -Jxf "${file}" < /dev/null || { echo "❌ Failed to decompress the file ${file}. Exiting."; exit 7; }

    cd "Python-${new_version}"

    clear
    echo ""
    echo "###############################################"
    echo "# Building and Installing new Python version  #"
    echo "###############################################"
    ./configure --enable-optimizations --prefix=/usr < /dev/null || { echo "❌ Configuration failed. Exiting."; exit 8; }
    make -j "$(nproc)" < /dev/null || { echo "❌ Build process failed. Exiting."; exit 9; }
    make altinstall -j "$(nproc)" < /dev/null || { echo "❌ Installation failed. Exiting."; exit 10; }

    clear
    echo ""
    echo "###############################################"
    echo "#         Cleaning up temporary files         #"
    echo "###############################################"
    cd ..
    rm -rf "Python-${new_version}" "${file}"

    clear
    echo ""
    echo "###############################################"
    echo "#                Installing PIP               #"
    echo "###############################################"
    apt -qq install -y python3-pip < /dev/null || { echo "❌ Failed to install PIP! Exiting."; exit 11; }

    clear
    echo ""
    echo "###############################################"
    echo "#                 Updating PIP                #"
    echo "###############################################"
    python"${py_main_version}" -m pip install --upgrade pip || { echo "❌ Failed to update PIP! Exiting."; exit 12; }

    clear
    echo ""
    echo "###############################################"
    echo "#   Setting up new Python version as default  #"
    echo "###############################################"
    update-alternatives --install /usr/bin/python python /usr/bin/python"${py_main_version}" 1
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python"${py_main_version}" 1

    # Fallback alias setup
    if [[ $(python"${py_main_version}" --version) != "${new_version}" ]]; then
        echo "alias python='/usr/bin/python${py_main_version}'" >> ~/.bashrc
        source ~/.bashrc
    fi

    clear
    echo "###############################################"
    echo "#         🎉 Installation Done! 🎉            #"
    echo "###############################################"
    echo ""
    echo "✅ Your new Python version should be: ${new_version}"
    echo "   You can verify it by running: 'python --version'"
    echo ""
    echo "💡 Tip: Use 'python3 --version' or 'python --version' to check the version"
    echo "   if multiple versions are installed."
    echo ""
    echo "🙏 If this script saved you time or made your life easier:"
    echo "   Consider supporting me with a tip/donation:"
    echo "   👉 https://donorbox.org/tvdsluijs-github"
    echo ""
    echo "🎉 Enjoy coding with your shiny new Python version! 🚀"
    echo "###############################################"
}

if [ -z "$1" ]; then
    clear
    echo "###############################################"
    echo "#            🚨 Error Detected! 🚨            #"
    echo "###############################################"
    echo ""
    echo "❌ You did not provide a Python version number."
    echo "   Please specify the version you want to install."
    echo ""
    echo "📖 Example usage:"
    echo "   bash python.sh 3.10.0"
    echo ""
    echo "💡 Tip: You can also enable verbose mode for debugging by adding '-v':"
    echo "   bash python.sh 3.10.0 -v"
    echo ""
    echo "###############################################"
    exit 1
fi

# Validate version format
if ! [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+[a-zA-Z0-9]*$ ]]; then
    echo "❌ Invalid Python version format. Please use a valid format like 'X.Y.Z', 'X.Y.Za1', 'X.Y.Zb1', or 'X.Y.Zrc1'."
    echo "   Exiting in 5 seconds..."
    sleep 5
    exit 1
fi

install_python "$1" "${2:-}"
