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
alias ls="exa"

#git
alias gs="git status"
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

#perf
alias perf-rep="perf report -g 'graph,0.5,caller'"
alias perf-rec="perf record -g"

#misc
alias c="clear"
alias chat="ssh bun@chat.shazow.net"
alias z="zathura"
alias stowd="stow -t/home/$USER -S *"
