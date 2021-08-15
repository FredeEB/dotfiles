export XDG_CONFIG=$HOME/.config
source $XDG_CONFIG/bash/aliases.bash

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

if [[ -x "$(command -v git)" ]]; then
    source /usr/share/git/completion/git-completion.bash
fi  

#requires fzf
if [[ -x "$(command -v fzf)" ]]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
fi 

#requires starship
eval "$(starship init bash)"
