-- bootstrap packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

-- general settings
vim.o.autochdir = true
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.expandtab = true
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.number = true
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.wildmode = 'longest,list'

local map = vim.api.nvim_set_keymap

map('n', '<Space>', '', {})
vim.g.mapleader = ' '

options = { noremap = true }
map('n', '<leader>gs', ':G<CR>', options)
map('n', '<C-x><C-f>', ':Lf<CR>', options)
map('n', '<C-s>', ':w<CR>', options)

require 'plugins'
vim.cmd('colo dracula')

require 'lsps'

-- keybinds
--nmap <Space>gs :G<CR>

--set nocompatible
--set ignorecase
--set hlsearch
--set tabstop=4
--
--set cot=menuone,noinsert,noselect shm+=c
--
--set softtabstop=4
--set expandtab
--set shiftwidth=4
--set number
--set wildmode=longest,list
--set cc=100
--set completeopt-=preview
--filetype plugin indent on
--syntax on
--
--
--
--command! Format execute 'lua vim.lsp.buf.formatting()'
--
--:lua << EOF
--    local nvim_lsp = require('lspconfig')
--    local on_attach = function(_, bufnr)
--       require('completion').on_attach()
--    end
--    local servers = {'clangd', 'gopls', 'tsserver', 'rls'}
--    for _, lsp in ipairs(servers) do 
--        nvim_lsp[lsp].setup {
--           on_attach = on_attach,
--        }
--    end
--EOF

