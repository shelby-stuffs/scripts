#!/bin/bash
clear

# Colours (or Colors in en_US)
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NORMAL='\033[0m'

# Install packages.
sudo apt update && sudo DEBIAN_FRONTEND=noninteractive \
        apt install \
        adb autoconf automake axel bc bison build-essential \
        ccache clang cmake curl expat flex g++ git git-lfs gnupg gperf \
        htop byobu llvm zsh lld  -y || abort "Setup Failed!"

sudo swapoff /swapfile
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

git config --global user.email "shelbyhell@proton.me"
git config --global user.name "Alexey Shelby"

cat <<'EOF' >> /etc/resolv.conf

nameserver 1.1.1.1
nameserver 8.8.8.8

EOF

# Unlimited history file
sed -i 's/HISTSIZE=.*/HISTSIZE=-1/g' $sh_rc
sed -i 's/HISTFILESIZE=.*/HISTFILESIZE=-1/g' $sh_rc

echo -e "Done."

# Increase tmux scrollback buffer size
echo -e "\nIncrease tmux scrollback buffer size..."
cat <<'EOF' >> .tmux.conf

set-option -g history-limit 6000

EOF

echo -e ${GREEN}"Setup Complete!"${NORMAL}
