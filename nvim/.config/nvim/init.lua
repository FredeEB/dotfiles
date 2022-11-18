-- bootstrap packer
local packer_bootstrap = false
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    packer_bootstrap = true
end

local m = require('functions.keymap')
m.key('n', '<Space>', '', {})
vim.g.mapleader = ' '

local packer = require('packer')
return packer.startup(function(use)

    use { 'wbthomason/packer.nvim' }

    -- common
    use { 'nvim-lua/popup.nvim' }
    use { 'nvim-lua/plenary.nvim' }
    -- snippets
    use { 'dawikur/algorithm-mnemonics.vim' }
    use { 'honza/vim-snippets' }
    use { 'l3mon4d3/luasnip' }
    -- cmp
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-path' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use { 'hrsh7th/nvim-cmp' }
    -- lsp
    use { 'neovim/nvim-lsp' }
    -- dap
    use { 'mfussenegger/nvim-dap' }
    use { 'rcarriga/nvim-dap-ui', config = function() require('dapui').setup() end }
    -- tools
    use { 'theprimeagen/harpoon' }
    -- telescope
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope.nvim' }
    -- treesitter
    use { 'mfussenegger/nvim-treehopper' }
    use { 'drybalka/tree-climber.nvim' }
    use { 'david-kunz/treesitter-unit' }
    use { 'nvim-treesitter/playground' }
    use { 'nvim-treesitter/nvim-treesitter' }
    -- theme
    use { 'kyazdani42/nvim-web-devicons' }
    use { 'nvim-lualine/lualine.nvim' }
    use { 'mofiqul/dracula.nvim' }
    use { 'https://gitlab.com/yorickpeterse/nvim-pqf', config = function() require('pqf').setup() end }
    -- git
    use { 'lewis6991/gitsigns.nvim' }
    use { 'sindrets/diffview.nvim' }
    use { 'theprimeagen/git-worktree.nvim' }
    use { 'timuntersberger/neogit' }
    -- misc
    use { 'yutkat/confirm-quit.nvim' }
    use { 'rcarriga/nvim-notify' }
    use { 'williamboman/mason.nvim', config = function() require('mason').setup() end }
    use { 'ojroques/nvim-osc52', config = function() require('osc52').setup() end }
    use { 'olimorris/persisted.nvim' }
    use { 'windwp/nvim-autopairs' }
    use { 'terrortylor/nvim-comment', config = function() require('nvim_comment').setup() end }
    use { 'mbbill/undotree' }
    use { 'kabbamine/zeavim.vim' }
    use { 'tversteeg/registers.nvim' }
    use { 'anuvyklack/hydra.nvim', requires = { 'anuvyklack/keymap-layer.nvim' } }
    use { 'lewis6991/spellsitter.nvim', config = function() require('spellsitter').setup() end }
    use { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end }
    use { 'xiyaowong/nvim-cursorword' }
    if packer_bootstrap == true then
        packer.sync()
    end
end)

