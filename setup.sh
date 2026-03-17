#!/usr/bin/env bash
# Interactive setup script to install packages and configure a system.

PKG_BASE="git wget curl unzip python3"
PKG_ZSH="zsh zsh-syntax-highlighting zsh-autosuggestions tmux" 
PKG_BETTER="eza bat btop fzf grc zoxide"

PKG_DEV="make vim gcc"
PKG_PIP="matplotlib"

PKG_TEX="texlive texlive-lang-german texlive-latex-extra texlive-math-extra texlive-science texlive-xetex texlive-generic-extra"



# find package manager
if   command -v apt-get &>/dev/null; then _INSTALL="sudo apt-get -y install"     # Debian/Ubuntu
elif command -v pacman  &>/dev/null; then _INSTALL="sudo pacman -S --noconfirm"  # Arch
elif command -v yum     &>/dev/null; then _INSTALL="sudo yum -y install"         # Red Hat/CentOS
elif command -v apk     &>/dev/null; then _INSTALL="sudo apk add"                # Alpine
elif command -v brew    &>/dev/null; then _INSTALL="brew install"                # macOS
elif command -v pkg     &>/dev/null; then _INSTALL="sudo pkg install -y"         # FreeBSD
else echo "Warning: no supported package manager found."; fi


# $1: prompt; returns 0 for yes, 1 for no
_confirm(){
    echo -n "$1 (y) "; read yn </dev/tty
    [ "$yn" != "${yn#[Yy]}" ]
}

# $1: Name, $2 pkg list
_install_pkgs(){
    echo "The following $1 programs will be installed: $2"
    if _confirm "Ok to install?"; then $_INSTALL $2; fi
}

_install_shell(){
    # prompt
    _install_pkgs "zsh" "${PKG_ZSH}"
    if command -v zsh &>/dev/null; then
        echo "Setting ZSH as default shell..."
        sudo chsh -s "$(command -v zsh)"
    fi
    if _confirm "Install starship?"; then
        curl -sS https://starship.rs/install.sh | sh
        grep -qxF 'eval "$(starship init zsh)"' ~/.zshrc \
            || echo '\neval "$(starship init zsh)"' >> ~/.zshrc
        echo "Starship init line added to ~/.zshrc"
    fi

    # install further packages
    _install_pkgs "improved" "${PKG_BETTER}"

    # copy config
    if _confirm "Overwrite config files (zshrc)?"; then
        curl https://raw.githubusercontent.com/emareg/sh/main/dotfiles/.zshrc > ~/.zshrc
        mkdir -p ~/.config/my
        curl https://raw.githubusercontent.com/emareg/sh/main/dotfiles/.config/my/myalias > ~/.config/my/myalias
    fi
}

_install_shell_scripts(){
    local REPO_DIR="$HOME/.local/share/emareg/sh"
    if [ -d "$REPO_DIR/.git" ]; then
        echo "Repository already cloned. Pulling latest changes..."
        cd "$REPO_DIR" && git pull
    else
        echo "Cloning repository to $REPO_DIR..."
        mkdir -p "$(dirname "$REPO_DIR")"
        git clone https://github.com/emareg/sh "$REPO_DIR"
    fi
    mkdir -p "$HOME/.local/bin"
    for script in "$REPO_DIR/bin/"*; do
        ln -sf "$script" "$HOME/.local/bin/$(basename "$script")"
        echo "Linked: $(basename "$script")"
    done
    echo "Done. Make sure ~/.local/bin is in your PATH."
}

_install_dotfiles(){
    local GIT_DIR="$HOME/.git-dotfiles"
    local GIT_USER
    GIT_USER=$(git config --get github.user 2>/dev/null || git config --get user.name 2>/dev/null)
    if [ -z "$GIT_USER" ]; then
        echo -n "GitHub username: "; read GIT_USER </dev/tty
    fi
    local REPO_URL="https://github.com/$GIT_USER/dotfiles"
    if [ -d "$GIT_DIR" ]; then
        echo "Dotfiles repo already set up. Pulling latest changes..."
        git --git-dir="$GIT_DIR" --work-tree="$HOME" pull
    else
        echo "Cloning $REPO_URL into $HOME (git-dir: $GIT_DIR)..."
        git clone --bare "$REPO_URL" "$GIT_DIR"
        git --git-dir="$GIT_DIR" --work-tree="$HOME" checkout
        git --git-dir="$GIT_DIR" --work-tree="$HOME" config status.showUntrackedFiles no
    fi
    echo "Done. Use: git --git-dir=$GIT_DIR --work-tree=\$HOME <command>"
}

_install_basic(){
    _install_pkgs "basic" "${PKG_BASE}"
}

_install_dev(){
    _install_pkgs "Development" "${PKG_DEV}"
}

_install_docker(){
    # install docker via official convenience script
    if command -v docker &>/dev/null; then
        echo "Docker is already installed: $(docker --version)"
    elif _confirm "Install Docker via official script?"; then
        curl -fsSL https://get.docker.com | sh
        sudo usermod -aG docker "$USER"
        echo "Docker installed. Log out and back in for group membership to take effect."
    fi

    # install lazydocker from GitHub releases
    if command -v lazydocker &>/dev/null; then
        echo "lazydocker is already installed: $(lazydocker --version)"
    elif _confirm "Install lazydocker?"; then
        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    fi
}


# main menu
echo "Will help to install/configure packages. Please choose. You will be asked again for confirmation."
echo ""
echo "   1.  Install Shell (zsh, starship)"
echo "   2.  Install Own Shell Scripts Symlinks (ipscan, sysinfo)"
echo "   3.  Install Dotfiles (clone to \$HOME with separate git-dir)"
echo "   4.  Install Basics (git, python)"
echo "   5.  Install Development (make, vim, gcc)"
echo "   6.  Install Docker + lazydocker"
echo "   *   Quit"
echo ""


# read -p "Your Choice: " mainchoice;
echo -n "Your Choice: "; read mainchoice </dev/tty
case "$mainchoice" in
    "1" ) _install_shell;;
    "2" ) _install_shell_scripts;;
    "3" ) _install_dotfiles;;
    "4" ) _install_basic;;
    "5" ) _install_dev;;
    "6" ) _install_docker;;
    *) exit 0;;
esac
