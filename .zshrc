! [[ -d $HOME/.zplug ]] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

setopt histignorealldups sharehistory

# # Use emacs keybindings even if our EDITOR is set to vi
bindkey -v

# # Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh/history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

case "$EMACS" in
    t)
	PROMPT_COMMAND=
	PS1="[\u@\h:\w]$ "
esac

export VISUAL="emacsclient -t"
export EDITOR="emacsclient -c"
export BROWSER="chromium-browser"

export ZPLUG_HOME=~/.zplug
source $ZPLUG_HOME/init.zsh

PROMT=prompt-nix-shell

#plugins
zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-autosuggestions"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "zsh-users/zsh-syntax-highlighting"
zplug "peco/peco", from:gh-r, as:command
zplug "hlissner/zsh-autopair", defer:2
zplug "spwhitt/nix-zsh-completions"
zplug "chisui/zsh-nix-shell"

#theme // witing for PR merge
# zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
# zplug "fredeeb/spaceship-prompt", use:spaceship.zsh, from:github, as:theme


if [ -f ~/.zsh/spaceship-prompt/spaceship.zsh ]; then
    source ~/.zsh/spaceship-prompt/spaceship.zsh
fi

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
