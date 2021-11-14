local m = require('functions.keymap')
-- which key
require('which-key').setup()
vim.o.timeoutlen = 400

-- notify
vim.notify = require('notify')

-- tmux
vim.g.tmux_navigator_no_mappings = 1
m.keys {
    {'n', '<C-h>', [[<cmd>TmuxNavigateLeft<cr>]]},
    {'n', '<C-j>', [[<cmd>TmuxNavigateDown<cr>]]},
    {'n', '<C-k>', [[<cmd>TmuxNavigateUp<cr>]]},
    {'n', '<C-l>', [[<cmd>TmuxNavigateRight<cr>]]}
}

-- wiki
vim.g.vimwiki_list = {{
    path = '~/wiki',
    syntax = 'markdown',
    ext = '.md'
}}

-- pears
require('pears').setup()

-- vim commentary
m.keys {
    {'v', '<leader>a', [[:'<,'>Commentary<cr>]]},
    {'n', '<leader>a', [[:Commentary<cr>]]},
}

-- undotree
m.key('n', 'U', [[<cmd>UndotreeToggle<cr>]])
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SetFocusWhenToggle = true
