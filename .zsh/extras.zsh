#create .bak files of input files
backup(){
    DATE=$(eval "date +%a%H%M")
    for var in "$@"
    do
	cp "$var" "$var.${DATE}.bak"
	echo "Created backup: $var.${DATE}.bak"
    done
}

#removes .bak files
cleanbackup(){
    rm -rf *.bak
    echo "Removed all .bak files"
}

#add to gitignore in git root
gign(){
    GIT_ROOT=$(eval "git rev-parse --show-toplevel")
    for var in "$@"
    do
	echo "\n$var" >> $GIT_ROOT/.gitignore
    done
}

#add alias
adda() {
    echo "alias $1=\"$2\"" >> ~/.zsh/aliases.zsh
    source ~/.zsh/aliases.zsh
}


# requires mpv, dmenu and ack... ONLY SUPPORTS WORD CHARACTERS AND WHITESPACE
function yt(){
    QUERY=
    for ARG in "$@"
    do
	QUERY="$QUERY $ARG"
    done
    QUERY=$(echo $QUERY | sed -e 's/ //' -e 's/ /+/g')
    URL=$(
    	curl --silent "https://www.youtube.com/results?search_query=$QUERY" | \
	    ack -o 'href="/watch\?v=[\w\-_=]{11}".*?title=".*?"' | uniq | \
	    sed -e 's/href="\(\/watch?v=.\{11\}\)".*title="\(.*\)"/\2 - https:\/\/youtube.com\1/' | \
	    dmenu -l 10 | sed -e 's/.*\(https.*\)/\1/'
       )
    mpv $URL --really-quiet &
}

function twitch(){
	NAME=$1
    mpv https://twitch.tv/$NAME --really-quiet & disown
}

function aur(){
    QUERY=$@
    PWD=$(pwd)
    cd /tmp
    rm -rf $QUERY
    git clone "https://aur.archlinux.org/$QUERY"
    cd $QUERY
    less PKGBUILD
    if read -q "REPLY?build?: [yN]"; then
	echo "\n\n"
	if makepkg -si; then
	    cd ..
	    rm -rf $QUERY
	    echo "installed $QUERY and cleaned up\n"
	    cd $PWD
	    return
	fi
    else
	if read -q "REPLY?remove?: [yN]\n"; then
	    cd ..
	    rm -rf $QUERY
	    echo "Removed $QUERY folder\n"
	    cd $PWD
	fi
    fi
}

function newcpprepo(){
	NAME=$@
	mkdir $NAME
	cd $NAME
	gh repo create --template cpptemplate $NAME
}

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
