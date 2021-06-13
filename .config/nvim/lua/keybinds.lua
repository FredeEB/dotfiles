-- keybinds
local map = vim.api.nvim_set_keymap

map('n', '<Space>', '', {})
vim.g.mapleader = ' '

options = { noremap = true }
map('n', '<leader>gs', ':G<CR>', options)
map('n', '<C-x><C-f>', ':Lf<CR>', options)
map('n', '<C-s>', ':w<CR>', options)
map('n', '<leader>b', ':Telescope buffers<CR>', options)
map('n', '<leader>fe', ':e $HOME/.config/nvim/init.lua<CR>', options)
map('n', '<leader>q', ':bdelete<CR>', options)
