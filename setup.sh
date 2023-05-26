#!/usr/bin/env bash

PKG_BASE="git wget curl unzip python3"
PKG_ZSH="zsh zsh-syntax-highlighting zsh-autosuggestions tmux" 
PKG_BETTER="exa bat dog btop fzf grc"

PKG_DEV="make vim gcc"
PKG_PIP="matplotlib"

PKG_TEX="texlive texlive-lang-german texlive-latex-extra texlive-math-extra texlive-science texlive-xetex texlive-generic-extra"





# find package manager
[[ -x "/usr/bin/apt-get" ]] && _INSTALL="sudo apt -y install "  # Ubuntu
[[ -x "/usr/bin/pacman" ]] && _INSTALL="sudo pacman -y install " # Arch
[[ -x "/usr/bin/yum" ]] && _INSTALL="sudo yum -y install "  # Red Hat
[[ -x "/usr/bin/pkg" ]] && _INSTALL="sudo pkg -y install "  # FreeBSD


# $1: Name, $2 pkg list
function _install_pkgs(){
	echo "The following $1 programs will be installed: $2"
	read -p "Ok to install? (y) " -n 1 -r; echo "";
    [[ ! $REPLY =~ ^[Yy]$ ]] && return 0

	$_INSTALL $2
}

function install_shell(){
    # prompt
    _install_pkgs "zsh" "${PKG_ZSH}"
    [ -x /bin/zsh ] && echo "Set ZSH shell:" && chsh -s $(which zsh)
    read -p "Install starship? (y) " -n 1 -r; echo "";
    [[ $REPLY =~ ^[Yy]$ ]] && curl -sS https://starship.rs/install.sh | sh

    PT_URL="https://raw.githubusercontent.com/emareg/Promptheus/master/install.sh"
    read -p "Install Promptheus? (y) " -n 1 -r; echo "";
    [[ $REPLY =~ ^[Yy]$ ]] && wget -O - ${PT_URL} | sh

    # install further packages
    _install_pkgs "improved" "${PKG_BETTER}"

    # copy config
    curl http://sh.emareg.de/dotfiles/.zshrc > ~/.zshrc
    mkdir -p .config/my
    curl http://sh.emareg.de/dotfiles/.config/my/myalias > ~/.config/my/myalias
}

function install_basic(){
    _install_pkgs "basic" "${PKG_BASE}"
}

function install_dev(){
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


read -p "Your Choice: " -n 1 mainchoice; echo ""
case $mainchoice in
    1 ) install_shell;;
    2 ) install_basic;;
    3 ) install_dev;;
    * ) exit 0;;
esac
