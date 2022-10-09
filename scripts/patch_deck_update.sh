#!/usr/bin/env bash
# A script to re-apply my patches to the steam deck when an update happens

set -e

if ! grep -q /nix /etc/fstab; then
    echo Adding nix mount to fstab
    sudo steamos-readonly disable
    echo "/home/deck/nix			  /nix    none	  defaults,bind		   0       0" >> /etc/fstab
    sudo steamos-readonly enable
fi

if ! [ -d /home/deck/nix ]; then
    echo Making /home/deck/nix directory
    mkdir /home/deck/nix
fi

if ! [ -d /nix ]; then
    echo Creating /nix directory
    sudo steamos-readonly disable
    sudo mkdir /nix
    sudo steamos-readonly enable

    echo Mounting /home/dekc/nix to /nix
    sudo mount /nix
fi

if ! [ -d /nix/store]; then
    echo Installing nix package manager
    sh <(curl -L https://nixos.org/nix/install) --no-daemon

    echo Sourcing nix profile
    . /home/deck/.nix-profile/etc/profile.d/nix.sh

    echo Installing home-manager
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    . /home/deck/.nix-profile/etc/profile.d/hm-session-vars.sh

    if ! [ -d /hom/deck/dotfiles ]; then
        echo Fetching dotifles
        nix-shell --packages git --command 'git clone git@github.com:seanybaggins/nix-home.git /home/deck/dotfiles'
    fi

    echo linking /home/deck/dotfiles/home.nix to /home/deck/.config/nixpkgs
    ln -sf /home/deck/dotfiles/home.nix /home/deck/.config/nixpkgs

    echo switching home-manager configuration
    home-manager switch
fi

echo Installing virtual box
sudo steamos-readonly disable
sudo pacman -S virtualbox
sudo steamos-readonly enable
