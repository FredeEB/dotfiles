function newcpprepo() {
    NAME=$1; shift
    gh repo create --template fredeeb/cpptemplate $NAME
}

alias gs="git status"
alias gd="git diff"

function gl() {
    COMMITISH=($@); shift
    git --no-pager log --oneline ${COMMITISH[@]} \
        | fzf -m --no-sort --reverse --preview "git --no-pager show --ext-diff {1}" \
            --bind "ctrl-d:preview-page-down" \
            --bind "ctrl-u:preview-page-up" \
            --bind "ctrl-o:execute(git checkout {1})+accept" \
            --bind "ctrl-r:execute(git rebase -i {1}^)+accept" \
            --bind "ctrl-a:execute-multi(git cherry-pick {1})+accept" \
            --bind "ctrl-s:execute(git show {1})+accept"
}; export -f gl

function gw() {
    DIR=($1); shift
    if [[ ! -z $DIR ]]; then
        PREFIX=$(git rev-parse --show-toplevel)
        DIR=$(echo $PWD | sed -e 's/$PREFIX//')
    fi

    TARGET=$(git worktree list \
        | grep -v "\[0\]" \
        | fzf -m --reverse --preview "git show" \
        | cut -f 1 -d ' ')/$DIR
    cd $TARGET
}

function gbr() {
    git --no-pager branch \
        | fzf --reverse --preview="git --no-pager log --oneline --color=always --graph {-1}" \
            --bind "ctrl-d:preview-page-down" \
            --bind "ctrl-u:preview-page-up" \
            --bind "enter:execute(git checkout {-1})+accept" \
            --bind "ctrl-r:execute(git rebase -i {-1})+accept" \
            --bind "ctrl-x:execute(git branch -d {-1})" \
            --bind "ctrl-s:execute(gl {-1})+accept"
}

function gba() {
    git --no-pager reflog\
        | fzf --no-sort --reverse --preview="git --no-pager show --ext-diff {1}" \
            --bind "ctrl-d:preview-page-down" \
            --bind "ctrl-u:preview-page-up" \
            --bind "enter:execute(git checkout {1})+accept" \
            --bind "ctrl-s:execute(gl {1})+accept" 
}

function gst() {
    git stash list \
        | fzf --no-sort --reverse --preview "git --no-pager stash show --color=always" \
            --bind "ctrl-d:preview-page-down" \
            --bind "ctrl-u:preview-page-up" \
            --bind "ctrl-s:execute(git stash show {1})" \
            --bind "ctrl-p:execute(git stash pop {1})+accept" \
            --bind "ctrl-b:execute(git stash branch {1}^)+accept"
}
