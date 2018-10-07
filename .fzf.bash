# Setup fzf
# ---------
if [[ ! "$PATH" == */home/bun/.fzf/bin* ]]; then
  export PATH="$PATH:/home/bun/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/bun/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/bun/.fzf/shell/key-bindings.bash"

