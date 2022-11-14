function v() {
    if [ -z "$NVIM" ]; then
        nvim $1
    else
        # save the bufnumber
        # TERMTOKILL="$(nvim --server $NVIM --remote-expr "bufnr()" 2>&1)"
        nvim --server $NVIM --remote-send "<cmd>cd $PWD | e ${1:-.}<cr>"
        # kill the bufnumber
        # TODO: This is broken
        # nvim --server $NVIM --remote-send "<cmd>${TERMTOKILL}bd!<cr>"
    fi
}; export -f v

function newcpprepo() {
    NAME=$1; shift
    gh repo create --template fredeeb/cpptemplate $NAME
}

alias gs="git status"
alias gd="git diff"

function gl() {
    COMMITISH=($@); shift
    git --no-pager log --oneline ${COMMITISH[@]} \
        | fzf --no-sort --reverse --preview "git --no-pager show --ext-diff {1}" \
            --bind "ctrl-d:preview-page-down" \
            --bind "ctrl-u:preview-page-up" \
            --bind "ctrl-s:execute(git show {1})" \
            --bind "ctrl-o:execute(git checkout {1})+accept" \
            --bind "ctrl-r:execute(git rebase -i {1}^)+accept" \
            --bind "ctrl-m:execute(git show {1})+accept"
}; export -f gl

function gbr() {
    git --no-pager branch \
        | fzf --reverse --preview="git --no-pager log --oneline --color=always --graph {-1}" \
            --bind "enter:execute(git checkout {-1})+accept" \
            --bind "ctrl-r:execute(git rebase -i {-1})+accept" \
            --bind "ctrl-d:execute(git branch -d {-1})" \
            --bind "ctrl-s:execute(gl {-1})+accept"
}

function gba() {
    git --no-pager reflog\
        | fzf --no-sort --reverse --preview="git --no-pager show --ext-diff {1}" \
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
