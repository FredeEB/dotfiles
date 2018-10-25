backup(){
    DATE=$(eval "date +%a%H%M")
    for var in "$@"
    do
	cp "$var" "$var.${DATE}.bak"
	echo "Created backup: $var.${DATE}.bak"
    done
}

cleanbackup(){
    rm -rf *.bak
    echo "Removed all .bak files"
}

agitign(){
    GIT_ROOT=$(eval "git rev-parse --show-toplevel")
    for var in "$@"
    do
	echo "\n$var" >> $GIT_ROOT/.gitignore
    done
}

adda() {
    echo "alias $1=\"$2\"" >> ~/.zsh/zsh_aliases.zsh 
    source ~/.zsh/zsh_aliases.zsh 
}
