# install zplug if not already installed
export ZPLUG_HOME=$HOME/.config/zplug
export PATH=$HOME/.local/bin:$PATH

[[ ! -d $ZPLUG_HOME ]] && git clone https://github.com/zplug/zplug $ZPLUG_HOME
source $ZPLUG_HOME/init.zsh

[[ -f /usr/bin/keychain ]] && eval $(keychain --eval --quiet id_rsa)

setopt histignorealldups sharehistory

# Use emacs keybinds
bindkey -e

# update PATH
export PATH=$HOME/.local/bin:$PATH

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

source ~/.zsh/keybinds.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/extras.zsh