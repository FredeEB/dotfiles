#devtools
alias e="emacs . &"
alias ec="emacsclient -c . & disown"
alias et="emacsclient -t"
alias gs="git status"
alias ne="nix-shell --command 'emacs . &'"
alias remacs="systemctl restart --user emacs"

#files
alias al="ls -lah"
alias cd..="cd .."
alias cp="cp -i"
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias la="ls -lah"
alias lr="ls -lahR | sed -e '/^total.*$/d' -e '/.*\\.$/d'"
alias ls='ls --color=auto'
alias mv="mv -i"
alias rf="rm -rf"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#git
alias gd="git diff"
alias gl="git log --graph --oneline --all"
alias gp="git pull"

#docker
alias dps="docker ps -a"
alias dcb="COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose build --parallel"
alias dcu="docker-compose up"
alias dcd="docker-compose up -d"
alias dck="docker-compose down"
alias dr="docker restart"

#misc
alias c="clear"
alias chat="ssh bun@chat.shazow.net"
alias s="shutdown +60"
alias z="zathura"
#unsorted
alias dk="setxkbmap dk"
alias us="setxkbmap us"
alias ls="exa"
