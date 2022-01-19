function newcpprepo() {
    NAME=$1; shift
    gh repo create --template fredeeb/cpptemplate $NAME
}

alias gs="git status"
alias gd="git diff"

function gl() {
    COMMITISH=$1; shift
    git --no-pager log --oneline $COMMITISH \
        | fzf --reverse --preview "git --no-pager diff --color=always {1}^ {1}" \
            --bind "ctrl-d:preview-page-down" \
            --bind "ctrl-u:preview-page-up" \
            --bind "ctrl-s:execute(git show {1})" \
            --bind "ctrl-o:execute(git checkout {1})+accept" \
            --bind "ctrl-r:execute(git rebase -i {1})+accept" \
            --bind "ctrl-m:execute(git show {1})+accept"
}; export -f gl

function gbr() {
    git --no-pager branch \
        | fzf --reverse --preview="git --no-pager log --oneline --color=always --graph {-1}" \
            --bind "enter:execute(git checkout {-1})+accept" \
            --bind "ctrl-s:execute(gl {-1})+accept"
}

function gba() {
    git --no-pager reflog\
        | fzf --reverse --preview="git --no-pager show --color=always {1}" \
            --bind "enter:execute(git checkout {1})+accept" \
            --bind "ctrl-s:execute(gl {1})+accept" 
}
