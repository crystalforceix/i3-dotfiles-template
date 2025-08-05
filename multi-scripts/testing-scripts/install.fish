#!/usr/bin/env fish


# Variables
set -q _flag_noconfirm && set noconfirm '--noconfirm'
set -q XDG_CONFIG_HOME && set -l config $XDG_CONFIG_HOME || set -l config $HOME/.config
set -q XDG_STATE_HOME && set -l state $XDG_STATE_HOME || set -l state $HOME/.local/state

# Helper funcs
function _out -a colour text
    set_color $colour
    # Pass arguments other than text to echo
    echo $argv[3..] -- ":: $text"
    set_color normal
end

function log -a text
    _out cyan $text $argv[2..]
end

function input -a text
    _out blue $text $argv[2..]
end

# Comfirm Function
function confirm-overwrite -a path
    if test -e $path -o -L $path
        # No prompt if noconfirm
        if set -q noconfirm
            input "$path already exists. Overwrite? [Y/n]"
            log 'Removing...'
            rm -rf $path
        else
            # Prompt user
            read -l -p "input '$path already exists. Overwrite? [Y/n] ' -n" confirm || exit 1

            if test "$confirm" = 'n' -o "$confirm" = 'N'
                log 'Skipping...'
                return 1
            else
                log 'Removing...'
                rm -rf $path
            end
        end
    end

    return 0
end

# Install yay if not already installed
if ! pacman -Q yay &> /dev/null
    log 'Yay not installed. Installing...'

    # Install
    sudo pacman -S --needed git base-devel $noconfirm
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay

    # Setup
    yay -Y --gendb
    yay -Y --devel --save
end

# Install crystal-clients package in aur-packages-stored folder.
log 'Installing dependancy packages for i3wm...'
yay -S i3-wm polybar dmenu kitty fastfetch brightnessctl pamixer pavucontrol htop nwg-look feh

# Install crystal-themes-fonts package in aur-packages-stored folder.
log 'Installing crystal-themes-fonts package in aur-packages-stored folder...'
yay -Bi ./../../aur-packages-stored/crystal-themes-fonts/ $noconfirm

# Install crystal-neovim package in aur-packages-stored folder.
log 'Installing crystal-neovim package in aur-packages-stored folder...'
yay -Bi ./../../aur-packages-stored/crystal-neovim/ $noconfirm


# Fish shell
if confirm-overwrite $config/fish
    log 'Installing fish shell config...'
    ln -s ./../i3-dotfiles-template/.config/fish $config/fish
end

# Posh themes
if confirm-overwrite $config/terminal-posh-themes
    log 'Installing posh themes config...'
    ln -s ./../i3-dotfiles-template/.config/terminal-posh-themes $config/terminal-posh-themes
end

# Neovim
if confirm-overwrite $config/nvim
    log 'Installing neovim config...'
    ln -s ./../i3-dotfiles-template/.config/nvim $config/nvim
end

# Swaync
if confirm-overwrite $config/i3
    log 'Installing i3 config...'
    ln -s ./../i3-dotfiles-template/.config/swaync $config/swaync
end

# Polybar
if confirm-overwrite $config/polybar
    log 'Installing polybar config...'
    ln -s ./../i3-dotfiles-template/.config/polybar $config/waybar
end

# Fastfetch config
if confirm-overwrite $config/fastfetch
    log 'Installing fastfetch config...'
    ln -s ./../i3-dotfiles-template/.config/fastfetch $config/fastfetch
end

# GTK theme config
if confirm-overwrite ~/.themes
    log 'Installing GTK themes...'
    ln -s ~/i3-dotfiles-template/.themes ~/.themes
end

# Mouse icon config
if confirm-overwrite ~/.icons
    log 'Installing Mouse icons themes...'
    ln -s ~/i3-dotfiles-template/.icons ~/.icons
end
