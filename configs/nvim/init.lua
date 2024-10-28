-- bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazy_path) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim',
        '--branch=stable',
        lazy_path,
    })
end
vim.opt.rtp:prepend(lazy_path)

local m = require('functions.keymap')
m.key('n', '<Space>', '')
vim.g.mapleader = ' '

require('lazy').setup({
    -- common
    { 'nvim-lua/plenary.nvim' },
    { 'folke/lazydev.nvim', config = true },
    -- tmux
    { 'aserowy/tmux.nvim', config = true },
    -- snippets
    { 'l3mon4d3/luasnip', dependencies = {"rafamadriz/friendly-snippets"} },
    -- cmp
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'tzachar/cmp-ai' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/nvim-cmp' },
    -- lsp
    { 'neovim/nvim-lsp' },
    -- dap
    { 'mfussenegger/nvim-dap' },
    { 'thehamsta/nvim-dap-virtual-text', config = true },
    { 'nvim-neotest/nvim-nio' },
    { 'rcarriga/nvim-dap-ui', config = true },
    { 'jbyuki/one-small-step-for-vimkind' },
    -- tools
    { 'simonmclean/triptych.nvim', config = true },
    { 'stevearc/oil.nvim', config = true },
    { 'theprimeagen/harpoon', branch = 'harpoon2' },
    { 'theprimeagen/refactoring.nvim' },
    { 'nvimtools/hydra.nvim' },
    { 'fredeeb/alias.nvim' },
    { 'fredeeb/tardis.nvim', config = true },
    { 'robitx/gp.nvim', config = true },
    -- fzf
    { 'ibhagwan/fzf-lua' },
    -- treesitter
    { 'mfussenegger/nvim-treehopper' },
    { 'nvim-treesitter/nvim-treesitter-context', config = true },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    -- theme
    { 'https://gitlab.com/yorickpeterse/nvim-pqf', config = true },
    { 'rebelot/kanagawa.nvim', config = true },
    -- git
    { 'akinsho/git-conflict.nvim', config = true },
    { 'lewis6991/gitsigns.nvim' },
    { 'sindrets/diffview.nvim', opts = { use_icons = false } },
    { 'neogitorg/neogit' },
    -- misc
    { 'rcarriga/nvim-notify' },
    { 'olimorris/persisted.nvim' },
    { 'windwp/nvim-autopairs', config = true },
    { 'kabbamine/zeavim.vim' },
    { 'numtostr/comment.nvim', config = true },
    { 'tversteeg/registers.nvim', config = true },
}, { lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json' })
