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
-- harpoon
require('harpoon').setup()
m.keys {
    {'n', '<M-a>', [[<cmd>lua require('harpoon.mark').add_file()<cr>]]},
    {'n', '<M-s>', [[<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>]]},
    {'n', '<M-j>', [[<cmd>lua require('harpoon.ui').nav_file(1)<cr>]]},
    {'n', '<M-k>', [[<cmd>lua require('harpoon.ui').nav_file(2)<cr>]]},
    {'n', '<M-l>', [[<cmd>lua require('harpoon.ui').nav_file(3)<cr>]]},
    {'n', '<M-;>', [[<cmd>lua require('harpoon.ui').nav_file(4)<cr>]]},
}

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
