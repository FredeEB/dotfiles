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
export PS1="🐧\[\033[36m\]\t \[$(tput sgr0)\]\[\033[35m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[32m\]\h\[$(tput sgr0)\] \w\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[34m\]\$(git branch --show-current 2> /dev/null | sed -e 's/.*/ \0/') \[$(tput sgr0)\]\n"
