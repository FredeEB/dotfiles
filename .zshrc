# install zplug if not already installed
! [[ -d $HOME/.zplug ]] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

setopt histignorealldups sharehistory

# Use vim keybinds
bindkey -v

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
zplug "chisui/zsh-nix-shell"
#zplug "sindresorhus/pure", use:"*.zsh", from:github, as:theme
zplug "hlissner/zsh-autopair", defer:2
zplug "isacikgoz/gitbatch", from:gh-r, as:command
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "ryutok/rust-zsh-completions"
zplug "spwhitt/nix-zsh-completions"
zplug "todb-r7/git-completion.bash"
zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

source ~/git/projects/pure/async.zsh
source ~/git/projects/pure/pure.zsh

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
