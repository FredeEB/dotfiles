#devtools
alias e="emacs . &"
alias ec="emacsclient -c . &"
alias et="emacsclient -t ."
alias gs="git status"
alias ne="nix-shell --command 'emacs . &'"
alias remacs="pkill emacs && emacs --daemon"
alias spi="ssh root@10.9.8.2"

#files
alias al="ls -lah"
alias cd..="cd .."
alias cp="cp -i"
alias la="ls -lah"
alias mv="mv -i"
alias r="ranger ."
alias rf="rm -rf"

#git
alias gd="git diff"
alias gl="git log --graph"
alias gp="git pull"

#nix
alias n="nix-shell"
alias ne="nix-shell --command 'emacs . &'"

#apt
alias inst="sudo apt install -y"
alias remo="sudo apt autoremove -y"
alias upgr="sudo apt update && sudo apt upgrade -y"

#misc
alias c="clear"
alias chat="ssh bun@chat.shazow.net"
alias sisu=". /opt/poky/2.6/environment-setup-arm1176jzfshf-vfp-poky-linux-gnueabi"
alias z="zathura"

#unsorted
