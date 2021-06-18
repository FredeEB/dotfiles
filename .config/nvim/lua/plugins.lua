vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use {'wbthomason/packer.nvim', opt = true}
    use {'junegunn/fzf.vim', run = function ()vim.fn['fzf#install']() end}
    use 'andymass/vim-matchup'
    use 'jiangmiao/auto-pairs'
    use '9mm/vim-closer'
    use 'tpope/vim-commentary'
    use 'dracula/vim'
    use 'jreybert/vimagit'
    use 'prabirshrestha/async.vim'
    use 'preservim/nerdtree'
    use 'neovim/nvim-lsp'
    use 'nvim-lua/completion-nvim'
    use 'tpope/vim-fugitive'
    use 'vim-airline/vim-airline'
    use 'jesseduffield/lazygit'
    use 'jesseduffield/lazydocker'
    use 'mbbill/undotree'
    use {'ptzz/lf.vim', requires = {{'voldikss/vim-floaterm'}}}
    use 'glacambre/firenvim'
    use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
    use {'lewis6991/gitsigns.nvim', requires = {{'nvim-lua/plenary.nvim'}}, config = function() require('gitsigns').setup() end}
    use 'glepnir/lspsaga.nvim'
end)
