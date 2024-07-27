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
    spec = { import = 'plugins' },
    lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
    dev = {
        path = "~/git",
        fallback = true,
    },
})

    -- -- common
    -- -- tmux
    -- -- snippets
   
    
    -- { 'stevearc/oil.nvim', config = true },
    -- { 'theprimeagen/harpoon', branch = 'harpoon2' },
    -- { 'theprimeagen/refactoring.nvim' },
    -- { 'nvimtools/hydra.nvim' },
    -- { 'fredeeb/alias.nvim' },
    -- { 'fredeeb/tardis.nvim', config = true },
    -- -- fzf
    -- { 'ibhagwan/fzf-lua' },
    -- -- treesitter
    -- { 'mfussenegger/nvim-treehopper' },
    -- { 'nvim-treesitter/nvim-treesitter-context', config = true },
    -- { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    -- -- theme
    -- { 'https://gitlab.com/yorickpeterse/nvim-pqf', config = true },
    -- { 'rebelot/kanagawa.nvim', config = true },
    -- -- git
    -- { 'akinsho/git-conflict.nvim', config = true },
    -- { 'lewis6991/gitsigns.nvim' },
    -- { 'sindrets/diffview.nvim', opts = { use_icons = false } },
    -- { 'neogitorg/neogit' },
    -- -- misc
