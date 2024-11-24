#!/usr/bin/env bash

if [[ "$(command -v apt)" != "" ]]; then
    echo "Debian/Ubuntu Based Distro Detected"
    bash ~/scripts/ubuntu/setup.sh
    cp -r ~/scripts/common/\.* ~/
    echo "source ~/scripts/ubuntu/alias" >> ~/.zshrc
elif [[ "$(command -v pacman)" != "" ]]; then
    echo "Arch Based Distro Detected"
    bash ~/scripts/arch/setup.sh
    cp -r ~/scripts/common/\.* ~/
    echo "source ~/scripts/arch/alias" >> ~/.zshrc
fi
