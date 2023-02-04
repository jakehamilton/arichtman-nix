#!/usr/bin/env bash
# Setup script for Mac


# Update the system
softwareupdate --install --all

# Disable fancy graphics
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.Mail DisableReplyAnimations -bool YES
defaults write com.apple.Mail DisableSendAnimations -bool YES
defaults write com.apple.dock expose-animation-duration -int 0
defaults write com.apple.dock springboard-show-duration -int 0
defaults write com.apple.dock springboard-hide-duration -int 0
# Hide Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
defaults write com.apple.dock no-bouncing -bool TRUE
killall Dock

# Install nix
curl -L https://nixos.org/nix/install | sh

# Need to reopen terminal
exit 0

# New terminal

nix-shell -p git

# Deploy our config and use
CONFIG_DIR=$HOME/.config/nix

mkdir -p $CONFIG_DIR
cp ./nix.conf $CONFIG_DIR

#region workarounds

# Until this is addressed https://github.com/LnL7/nix-darwin/issues/149
sudo mv /etc/nix/nix.conf /etc/nix/.nix-darwin.bkp.nix.conf

# Need to symlink /run directory
# These are copied from the error message directly
printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

#endregion

# Optional, but recommended
nix flake update

nix build .#darwinConfigurations.macbookpro.system

./result/sw/bin/darwin-rebuild switch --flake .#macbookpro

# home-manager switch

popd
