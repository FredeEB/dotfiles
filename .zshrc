# Check if terminal is dumb (e.g tramp)
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# install zplug if not already installed
export ZPLUG_HOME=$HOME/.config/zplug

[[ ! -d $ZPLUG_HOME ]] && git clone https://github.com/zplug/zplug $ZPLUG_HOME
source $ZPLUG_HOME/init.zsh

setopt histignorealldups sharehistory

# Use emacs keybinds
bindkey -e

# # Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh/history

export VISUAL="nvim"
export EDITOR=$VISUAL
export BROWSER="firefox"

#plugins
zplug "sindresorhus/pure", use:"*.zsh", from:github, as:theme
zplug "hlissner/zsh-autopair", defer:2
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "ryutok/rust-zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

#handle pugins
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

source ~/.zsh/vterm.zsh 
source ~/.zsh/keybinds.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/extras.zsh

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi
