#!/usr/bin/env bash

PKG_BASE="git wget curl unzip python3"
PKG_ZSH="zsh zsh-syntax-highlighting zsh-autosuggestions tmux" 
PKG_BETTER="exa bat btop fzf grc"

PKG_DEV="make vim gcc"
PKG_PIP="matplotlib"

PKG_TEX="texlive texlive-lang-german texlive-latex-extra texlive-math-extra texlive-science texlive-xetex texlive-generic-extra"



# find package manager
[ -x "/usr/bin/apt-get" ] && _INSTALL="sudo apt -y install "  # Ubuntu
[ -x "/usr/bin/pacman" ] && _INSTALL="sudo pacman -y install " # Arch
[ -x "/usr/bin/yum" ] && _INSTALL="sudo yum -y install "  # Red Hat
[ -x "/usr/bin/pkg" ] && _INSTALL="sudo pkg -y install "  # FreeBSD


# $1: Name, $2 pkg list
_install_pkgs(){
	echo "The following $1 programs will be installed: $2"
    echo -n "Ok to install? (y) "; read yn </dev/tty
    if [ "$yn" != "${yn#[Yy]}" ]; then $_INSTALL $2; fi
}

_install_shell(){
    # prompt
    _install_pkgs "zsh" "${PKG_ZSH}"
    [ -x /bin/zsh ] && echo "Set ZSH shell:" && chsh -s $(which zsh)
    echo -n "Install starship? (y) "; read yn </dev/tty
    if [ "$yn" != "${yn#[Yy]}" ]; then  curl -sS https://starship.rs/install.sh | sh; fi

    PT_URL="https://raw.githubusercontent.com/emareg/Promptheus/master/install.sh"
    echo -n "Install Promptheus? (y) "; read yn </dev/tty
    if [ "$yn" != "${yn#[Yy]}" ]; then wget -O - ${PT_URL} | sh; fi

    # install further packages
    _install_pkgs "improved" "${PKG_BETTER}"

    # copy config
    echo -n "Overwrite config files (zshrc)? (y) "; read yn </dev/tty
    if [ "$yn" != "${yn#[Yy]}" ]; then
        curl http://sh.emareg.de/dotfiles/.zshrc > ~/.zshrc
        mkdir -p .config/my
        curl http://sh.emareg.de/dotfiles/.config/my/myalias > ~/.config/my/myalias
    fi
}

_install_basic(){
    _install_pkgs "basic" "${PKG_BASE}"
}

_install_dev(){
    _install_pkgs "Development" "${PKG_DEV}"
}


# main menu
echo "Will help to install/configure packages. Please choose. You will be asked again for confirmation."
echo ""
echo "   1.  Install Shell (zsh, starship)"
echo "   2.  Install Basics (git, python)"
echo "   3.  Install Development (make, vim, gcc)"
echo "   *   Quit"
echo ""


# read -p "Your Choice: " mainchoice;
echo -n "Your Choice: "; read mainchoice </dev/tty
case "$mainchoice" in
    "1" ) _install_shell;;
    "2" ) _install_basic;;
    "3" ) _install_dev;;
    *) exit 0;;
esac
