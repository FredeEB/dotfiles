-- bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if vim.fn.empty(vim.fn.glob(lazy_path)) > 0 then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim', '--branch=stable', lazy_path })
end
vim.opt.rtp:prepend(lazy_path)

local m = require('functions.keymap')
m.key('n', '<Space>', '', {})
vim.g.mapleader = ' '

require('lazy').setup {
    -- common
    { 'nvim-lua/popup.nvim' },
    { 'nvim-lua/plenary.nvim' },
    -- snippets
    { 'dawikur/algorithm-mnemonics.vim' },
    { 'honza/vim-snippets' },
    { 'l3mon4d3/luasnip' },
    -- cmp
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/nvim-cmp' },
    -- lsp
    { 'neovim/nvim-lsp' },
    -- dap
    { 'mfussenegger/nvim-dap' },
    { 'rcarriga/nvim-dap-ui', config = function() require('dapui').setup() end },
    { 'jay-babu/mason-nvim-dap.nvim' },
    -- tools
    { 'theprimeagen/harpoon' },
    -- telescope
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    { 'nvim-telescope/telescope.nvim' },
    { 'debugloop/telescope-undo.nvim' },
    -- treesitter
    { 'mfussenegger/nvim-treehopper' },
    { 'nvim-treesitter/playground' },
    { 'nvim-treesitter/nvim-treesitter' },
    -- theme
    { 'kyazdani42/nvim-web-devicons' },
    { 'nvim-lualine/lualine.nvim' },
    { 'mofiqul/dracula.nvim' },
    { 'https://gitlab.com/yorickpeterse/nvim-pqf', config = function() require('pqf').setup() end },
    -- git
    { 'tanvirtin/vgit.nvim' },
    { 'theprimeagen/git-worktree.nvim' },
    { 'timuntersberger/neogit' },
    { 'sindrets/diffview.nvim' },
    -- misc
    { 'rcarriga/nvim-notify' },
    { 'williamboman/mason.nvim', config = function() require('mason').setup() end },
    { 'ojroques/nvim-osc52' },
    { 'olimorris/persisted.nvim' },
    { 'windwp/nvim-autopairs' },
    { 'numToStr/Comment.nvim' },
    { 'kabbamine/zeavim.vim' },
    { 'tversteeg/registers.nvim', config = function() require('pqf').setup() end },
    { 'anuvyklack/hydra.nvim', requires = { 'anuvyklack/keymap-layer.nvim' } },
    { 'lewis6991/spellsitter.nvim' },
    { 'xiyaowong/nvim-cursorword' },
}
