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
