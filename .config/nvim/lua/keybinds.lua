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
map('n', '<leader>Q', ':q!<CR>', options)
map('n', '<leader>h', ':<C-w>h<CR>', options)
map('n', '<leader>j', ':<C-w>j<CR>', options)
map('n', '<leader>k', ':<C-w>k<CR>', options)
map('n', '<leader>l', ':<C-w>l<CR>', options)
map('n', '<leader>fd', ':Explore<CR>', options)
map('n', '<leader>re', ':Lspsaga code_action<CR>', options)
map('n', '<leader>ro', ':Lspsaga rename<CR>', options)
map('n', '<leader>rd', ':Lspsaga preview_definition<CR>', options)
map('n', '<leader>rf', ':Lspsaga lsp_finder<CR>', options)
