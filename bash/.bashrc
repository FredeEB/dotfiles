export XDG_CONFIG=$HOME/.config
source $XDG_CONFIG/bash/aliases.bash
source $XDG_CONFIG/bash/functions.bash

set -o emacs

if [[ -x "$(command -v keychain)" ]]; then
    eval "$(keychain --eval --quiet id_rsa)"
fi

if [[ -x "$(command -v nvim)" ]]; then
    export EDITOR=nvim
    export VISUAL=$EDITOR
fi

if [[ -x "$(command -v firefox)" ]]; then
    export BROWSER=firefox
fi

#requires fzf
if [[ -x "$(command -v fzf)" ]]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
fi 

if [[ -f $HOME/.local/fzf-tab-completion/bash/fzf-bash-completion.sh ]]; then
    source ${HOME}/.local/fzf-tab-completion/bash/fzf-bash-completion.sh
    bind -x '"\t": fzf_bash_completion'
fi

bind Space:magic-space

export PATH=$HOME/.cargo/bin:$PATH

#history file
export HISTSIZE=10000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:history"
shopt -s histappend
PROMT_COMMAND="$PROMT_COMMAND; history -a"

#requires starship
eval "$(starship init bash)"
