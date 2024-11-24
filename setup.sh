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
	ccache clang cmake curl expat fastboot flex g++ \
	g++-multilib gawk gcc gcc-multilib git git-lfs gnupg gperf \
	htop imagemagick lib32ncurses5-dev lib32z1-dev libtinfo5 libc6-dev libcap-dev \
	libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses5-dev \
	libsdl1.2-dev libssl-dev libtool libxml2 libxml2-utils '^lzma.*' lzop \
	maven ncftp ncurses-dev patch patchelf pkg-config pngcrush \
	pngquant python2.7 python-all-dev re2c schedtool squashfs-tools subversion \
	texinfo unzip w3m xsltproc zip zlib1g-dev lzip \
	libxml-simple-perl libswitch-perl apt-utils libncurses5 libelf-dev cpio curl python-is-python3 byobu rclone llvm zsh lld  -y || abort "Setup Failed!"

sudo curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
sudo chmod a+rx /usr/local/bin/repo

sudo -v ; curl https://rclone.org/install.sh | sudo bash

# Setup 8GB swap.
sudo swapoff /swapfile
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Setup Git configs...
git config --global user.email "shelbyhell@proton.me"
git config --global user.name "Alexey Shelby"
git config --global review.gerrit.aospa.co.username "ShelbyHell"

git config --global alias.cp 'cherry-pick'
git config --global alias.c 'commit'
git config --global alias.f 'fetch'
git config --global alias.m 'merge'
git config --global alias.rb 'rebase'
git config --global alias.rs 'reset'
git config --global alias.ck 'checkout'
git config --global credential.helper 'cache --timeout=99999999'

# Setup Google and Cloudflare DNS.
cat <<'EOF' >> /etc/resolv.conf

nameserver 1.1.1.1
nameserver 8.8.8.8

EOF

# Setup macros.
if [[ $SHELL = *zsh* ]]; then
sh_rc=".zshrc"
else
sh_rc=".bashrc"
fi

cat <<'EOF' >> $sh_rc

# Super-fast repo sync
repofastsync() { time schedtool -B -e ionice -n 0 `which repo` sync -c --force-sync --current-branch --optimized-fetch --no-tags --no-clone-bundle --retry-fetches=5 -j8 "$@"; }

aospainit() { mkdir aospa && cd aospa && time schedtool -B -e ionice -n 0 `which repo` init --depth=1 --no-repo-verify -u https://github.com/AOSPA/manifest -b uvite -g default,-mips,-darwin,-notdefault
 "$@"; }

repofailfetch() { time schedtool -B -e ionice -n 0 `which repo` sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --retry-fetches=5 -j8 "$@"; }

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache

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
