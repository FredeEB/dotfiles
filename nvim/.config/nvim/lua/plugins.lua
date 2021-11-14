-- bootstrap packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(vim.fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute('packadd packer.nvim')
end

vim.cmd('packadd packer.nvim')
-- autoload file when it changes
vim.cmd('autocmd BufWritePost plugins.lua source <afile> | PackerCompile')

return require('packer').startup(function()
    -- packagemanager, kept optional as it's bootstrapped in init.lua
    use {'wbthomason/packer.nvim', opt = true}

    -- widely used shared plugins
    use {'nvim-lua/popup.nvim'}
    use {'nvim-lua/plenary.nvim'}

    -- treesitter
    use {'david-kunz/treesitter-unit'}
    use {'nvim-treesitter/nvim-treesitter'}

    -- telescope
    use {'nvim-telescope/telescope-project.nvim'}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use {'nvim-telescope/telescope.nvim'} 

    -- snippets
    use {'honza/vim-snippets'}
    use {'quangnguyen30192/cmp-nvim-ultisnips'}
    use {'dawikur/algorithm-mnemonics.vim'}
    use {'sirver/ultisnips'}

    -- lsp
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-path'}
    use {'ray-x/cmp-treesitter'}
    use {'hrsh7th/nvim-cmp'}
    use {'theprimeagen/refactoring.nvim'}
    use {'neovim/nvim-lsp'}

    -- debugging
    use {'sakhnik/nvim-gdb', run = './install.sh' }

    -- misc utilities
    use {'andymass/vim-matchup'}
    use {'kevinhwang91/nvim-bqf'}
    use {'ggandor/lightspeed.nvim'}
    use {'folke/which-key.nvim'}
    use {'folke/trouble.nvim'}
    use {'rcarriga/nvim-notify'}
    use {'steelsojka/pears.nvim'}
    use {'prabirshrestha/async.vim'}
    use {'tpope/vim-surround'}
    use {'tpope/vim-abolish'}
    use {'tpope/vim-commentary'}
    use {'kkoomen/vim-doge'}
    use {'mbbill/undotree'}
    use {'neomake/neomake'}
    use {'christoomey/vim-tmux-navigator'}
    use {'andersevenrud/compe-tmux', branch = 'cmp'}
    use {'lukas-reineke/format.nvim'}
    use {'vimwiki/vimwiki'}
    use {'kabbamine/zeavim.vim'}

    -- theme
    use {'nvim-lualine/lualine.nvim', requires = {{'kyazdani42/nvim-web-devicons'}}}
    use {'fredeeb/dracula.nvim'}
    
    -- git
    use {'lewis6991/gitsigns.nvim'}
    use {'theprimeagen/git-worktree.nvim'}
    use {'sindrets/diffview.nvim'}
    use {'rhysd/git-messenger.vim'}
    use {'kdheepak/lazygit.nvim'}
end)
