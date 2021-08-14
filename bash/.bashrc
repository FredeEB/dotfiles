export XDG_CONFIG=$HOME/.config
source $XDG_CONFIG/bash/aliases.bash

#requires fzf
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

#requires starship
eval "$(starship init bash)"
