export PATH="$PATH:$HOME/.rvm/bin:$HOME/.local/bin" # Add RVM to PATH for scripting
export LESS='-R --use-color -Dd+r$Du+b' # color less

# basic options
setopt autocd autopushd
setopt extendedglob
bindkey -v   # vim keys


# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data


# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit promptinit colors
compinit
promptinit
colors

# Own keybindings. "-s" for strings instead of commands
# bindkey -s '^o' 'cd "$(find * -type d | fzf)"\n'
bindkey -s '^q' 'exit\n'
bindkey -s '^w' 'exit\n'
bindkey -s '^o' 'ji\n'
bindkey -s '^p' 'history | fzf\n'



# Load extensions
# -------------------------------------

# starship prompt. Installed via pkg manager
command -v starship >/dev/null 2>&1 && { eval "$(starship init zsh)" }

# zoxide autojump with "j". Installed via pkg manager
command -v zoxide >/dev/null 2>&1 && { eval "$(zoxide init --cmd j zsh)" }

# Load Plugins (installed via "sudo apt install zsh-autosuggestions")
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load FZF keybindings. Created during fzf installation
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# load my alias. Installed via dotfiles repo
[ -f ~/.config/my/myalias ] && source ~/.config/my/myalias

