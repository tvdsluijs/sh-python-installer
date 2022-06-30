#!/usr/bin/env sh
#
# This script is for installing python 3.x.x
#
# Copyright (c) 2021 itheo.tech
# MIT License
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Run this by
# sudo bash python.sh 3.11.0
# or via github by
# wget -qO - https://raw.githubusercontent.com/tvdsluijs/sh-python-installer/main/python.sh | sudo bash -s 3.10.0

set -euo pipefail

install_python () {
    new_version="$1"
    py_main_version=$(echo "$new_version" | sed '/[.].*[.].*/s/[.][^.]*$//')
    file="Python-${new_version}.tar.xz"
    url="https://www.python.org/ftp/python/${new_version}/${file}"

    #sometimes no python is installed at all!!
    if [[ $(command -v python) ]]; then
        old_version=$(python -c 'import platform; print(platform.python_version())')
    else
        old_version="0"
    fi

    if [ "$(printf '%s\n' "$new_version" "$old_version" | sort -V | head -n1)" = "$new_version" ]; then
        echo "You are trying to install an older version than your current version!"
        echo "Exiting this script!"
        exit 0
    fi

    echo "Your current Python version is: ${old_version}"

    echo "Updating & upgrading system"
    apt -qq update && apt --yes --force-yes upgrade < /dev/null

    echo "Installing system essentials"
    # sometimes the checkinstall package does not exists and then things break. I guess this is not the best solution, but don't know how to fix this.
    if [[ $(command -v checkinstall) ]]; then
        apt -qq install -y wget build-essential checkinstall < /dev/null
    else
        apt -qq install -y wget build-essential < /dev/null
    fi

    echo "Installing Python essentials"
    apt -qq install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev < /dev/null

    echo "Downloading Python ${new_version}"
    wget "${url}"
    echo "Decompressing file"
    tar -Jxf "${file}" < /dev/null

    cd "Python-${new_version}"

    echo "Prepare the source for the installation"
    ./configure --enable-optimizations --prefix=/usr < /dev/null
    make < /dev/null
    echo "(Install the new Python version $new_version)"
    make altinstall < /dev/null

    echo "Let's cleanup!"
    cd ..
    rm -rf "Python-$new_version"
    rm -r "${file}"

    echo "Let's install PIP"
    apt -qq install -y python3-pip < /dev/null

    echo "updating pip..."
    python"${py_main_version}" -m pip install --upgrade pip

    new_python_version=$(python -c 'import platform; print(platform.python_version())')
    if [ "$new_python_version" = "$new_version" ]; then
        echo "Version okay!"
    else
        echo "Okay, let's try to get your new installed to be the default!"
        update-alternatives --install /usr/bin/python python /usr/bin/python"${py_main_version}" 1
        update-alternatives --install /usr/bin/python3 python3 /usr/bin/python"${py_main_version}" 1
    fi

    if [ "$new_python_version" = "$new_version" ]; then
        echo "Version okay!"
    else
        echo "Okay, Still not good let's try something else!"
        echo "alias python='/usr/bin/python${py_main_version}'" >> ~/.bashrc
        source ~/.bashrc
    fi

    clear
    echo "All Done!"
    echo "Your new Python version should be ${new_version}"
    echo "You can check this yourself by 'python --version'"
    echo ""
    echo "Do not forget to give me a tip/donation for my work!"
    echo "https://donorbox.org/tvdsluijs-github"
    echo ""
    echo "Any questions?"
    echo "Visit my site and contact me on my contact page https://itheo.tech/contact"
    echo ""
    echo "Have Fun!"
}


while true; do
    read -p "Updating Python directly on your OS is not a good Idea! Are you aware with the problems you can cause? [y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please read https://itheo.tech/stop-updating-python-on-your-raspberry-pi-os-or-ubuntu"; exit;;
        * ) echo "Please answer y (yes) or n (no).";;
    esac
done


if [ -z "$1" ]; then
    echo "Sorry you did not provide a version number. (eg. 3.10.0)"
    echo "bash python.sh 3.10.0"
else
    install_python "$1"
fi