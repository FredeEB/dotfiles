local m = require('functions.keymap')

m.keys { -- tmux
    { 'n', '<leader>t', [[<cmd>!tmux split-window -h -c %:p:h<cr><cmd>redraw!<cr>]] },
    { 'n', '<leader>gr', [[<cmd>!tmux split-window -h -c `git rev-parse --show-toplevel`<cr><cmd>redraw!<cr>]] }
}

