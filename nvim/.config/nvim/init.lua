-- bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if vim.fn.empty(vim.fn.glob(lazy_path)) > 0 then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim', '--branch=stable', lazy_path })
end
vim.opt.rtp:prepend(lazy_path)

local m = require('functions.keymap')
m.key('n', '<Space>', '')
vim.g.mapleader = ' '

require('lazy').setup {
    -- common
    { 'nvim-lua/plenary.nvim' },
    { 'folke/neodev.nvim', config = true },
    -- tmux
    { 'aserowy/tmux.nvim', config = true },
    -- snippets
    { 'dawikur/algorithm-mnemonics.vim' },
    { 'rafamadriz/friendly-snippets' },
    { 'l3mon4d3/luasnip' },
    -- cmp
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/nvim-cmp' },
    -- lsp
    { 'neovim/nvim-lsp' },
    { 'dgagn/diagflow.nvim', config = true },
    -- dap
    { 'mfussenegger/nvim-dap' },
    { 'thehamsta/nvim-dap-virtual-text', config = true },
    { 'rcarriga/nvim-dap-ui', config = true },
    { 'jay-babu/mason-nvim-dap.nvim' },
    -- tools
    { 'theprimeagen/harpoon' },
    { 'fredeeb/tardis.nvim', config = true, dir = os.getenv('HOME') .. '/git/tardis.nvim' },
    -- fzf
    { 'ibhagwan/fzf-lua' },
    -- treesitter
    { 'mfussenegger/nvim-treehopper' },
    { 'nvim-treesitter/playground' },
    { 'nvim-treesitter/nvim-treesitter', run = ":TSUpdate" },
    { 'wansmer/treesj', config = true },
    -- theme
    { 'nvim-lualine/lualine.nvim' },
    { 'folke/tokyonight.nvim' },
    { 'https://gitlab.com/yorickpeterse/nvim-pqf', config = true },
    -- git
    { 'lewis6991/gitsigns.nvim' },
    { 'sindrets/diffview.nvim', opts = { use_icons = false } },
    { 'theprimeagen/git-worktree.nvim' },
    { 'neogitorg/neogit' },
    -- misc
    { 'rcarriga/nvim-notify' },
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim', config = true },
    { 'ojroques/nvim-osc52' },
    { 'fredeeb/alias.nvim' },
    { 'olimorris/persisted.nvim' },
    { 'windwp/nvim-autopairs', config = true },
    { 'numToStr/Comment.nvim', config = true },
    { 'kabbamine/zeavim.vim' },
    { 'tversteeg/registers.nvim', config = true },
    { 'lewis6991/spellsitter.nvim' },
}
