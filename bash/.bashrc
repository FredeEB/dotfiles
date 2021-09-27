export XDG_CONFIG=$HOME/.config
source $XDG_CONFIG/bash/aliases.bash
source $XDG_CONFIG/bash/functions.bash

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
    source ${HOME}/.local/fzf-tab-completion/bash/fzf-bash-completion.sh
    bind -x '"\t": fzf_bash_completion'
fi 

#history file
shopt -s histappend
PROMT_COMMAND="history -a; history -n; $PROMT_COMMAND"

#requires starship
eval "$(starship init bash)"
