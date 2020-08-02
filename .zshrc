# Check if terminal is dumb (e.g tramp)
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# install zplug if not already installed
export ZPLUG_HOME=$HOME/.zplug

[[ ! -f $ZPLUG_HOME/init.zsh ]] && git clone https://github.com/zplug/zplug $ZPLUG_HOME
source $ZPLUG_HOME/init.zsh

zplug "zplug/zplug", hook-build:'zplug --self-manage'

setopt histignorealldups sharehistory

# Use emacs keybinds
bindkey -e

# # Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh/history


export VISUAL="emacsclient -t"
export EDITOR="emacsclient -c"
export BROWSER="firefox"

export ZPLUG_HOME=~/.zplug
source $ZPLUG_HOME/init.zsh

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

#Keybinds
if [ -f ~/.zsh/keybinds.zsh ]; then
    source ~/.zsh/keybinds.zsh
fi

#Aliases
if [ -f ~/.zsh/aliases.zsh ]; then
    source ~/.zsh/aliases.zsh
fi

#Extras
if [ -f ~/.zsh/extras.zsh ]; then
    source ~/.zsh/extras.zsh
fi
