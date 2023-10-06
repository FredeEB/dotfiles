export DOTFILES_HOME=$(git -C $(dirname $(readlink -f ${BASH_SOURCE[0]})) rev-parse --show-toplevel)
export XDG_CONFIG=$HOME/.config
source "$XDG_CONFIG/bash/aliases.bash"

if [[ -x "$(which stow)" ]]; then
    cd $DOTFILES_HOME > /dev/null
    stow -S * -t $HOME
    cd - > /dev/null
fi

set -o emacs

if [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
fi

if [[ -x "$(which nvim)" ]]; then
    export EDITOR=nvim
    export VISUAL=$EDITOR
fi

if [[ -x "$(which firefox)" ]]; then
    export BROWSER=firefox
fi

#requires fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden"
export FZF_DEFAULT_OPTS="--preview 'cat' --bind 'ctrl-d:preview-page-down,ctrl-u:preview-page-up'"

if [[ -d /usr/share/fzf ]]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    complete -F _fzf_path_completion -o default -o bashdefault v
fi 

bind Space:magic-space

if [[ -z "$SSH_TTY" ]]; then
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
fi

if [[ -f $HOME/.config/bash/company.sh ]]; then
    source "$HOME/.config/bash/company.sh"
fi

#history file
export HISTSIZE=10000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:history"
shopt -s histappend
PROMT_COMMAND="$PROMT_COMMAND; history -a"

# generated with https://bashrcgenerator.com/
export PS1="\[\033[36m\]\t \[$(tput sgr0)\]\[\033[35m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[32m\]\h\[$(tput sgr0)\] \w\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[34m\]\$(git branch --show-current 2> /dev/null | sed -e 's/.*/ \0/') \[$(tput sgr0)\]\n\[\033[34m\]❯\[$(tput sgr0)\] "
