
-- general settings
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.expandtab = true
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.nu = true
vim.o.scrolloff = 15
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.wildmode = 'longest,list'
vim.o.inccommand = 'nosplit'
vim.o.termguicolors = true

local m = require('functions.keymap')

m.key('n', '<Space>', '', {})
vim.g.mapleader = ' '

m.keys{ -- undo tags
    {'i', ',', [[<C-g>u,]]},
    {'i', '.', [[<C-g>u.]]},
    {'i', '!', [[<C-g>u!]]},
    {'i', '?', [[<C-g>u?]]},
    {'i', ';', [[<C-g>u;]]},
}

m.keys{ -- vblock moves
    {'v', 'K', [[:m '<-2<cr>gv=gv]]},
    {'v', 'J', [[:m '>+1<cr>gv=gv]]},
}

m.keys{ -- closing files
    {'n', '<leader>q', [[<cmd>bdelete<cr>]]},
    {'n', '<leader>Q', [[<cmd>q!<cr>]]},
}

m.keys{ -- clipboard
    {'v', '<leader>y', '"+y'},
    {'n', '<leader>y', '"+y'},
    {'n', '<leader>Y', '"+Y'},
    {'n', '<leader>p', '"+p'},
    {'n', '<leader>P', '"+P'},
}

m.keys{ -- tmux
    {'n', '<leader>t', [[<cmd>!tmux split-window -h -c %:p:h<cr><cmd>redraw!<cr>]]},
    {'n', '<leader>gr', [[<cmd>!tmux split-window -h -c `git rev-parse --show-toplevel`<cr><cmd>redraw!<cr>]]}
}

m.keys{ -- qfl
    {'n', '<C-p>', [[<cmd>cprev<cr>]]},
    {'n', '<C-n>', [[<cmd>cnext<cr>]]},
    {'n', '<C-q>', [[<cmd>copen<cr>]]},
    {'n', '<C-c>', [[<cmd>cclose<cr>]]},
    {'n', '*', [[:execute 'vimgrep '.expand('<cword>').' '.expand('%') | :copen | :cc<cr>]]}
}

m.keys{ -- misc
    {'n', 'n', [[nzzzv]]},
    {'n', 'N', [[Nzzzv]]},
    {'n', 'J', [[mzJ`z]]},
}

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
vim.cmd('autocmd BufWritePost ~/.config/nvim/init.lua source <afile> | PackerCompile')

require('packer').startup(function(use)
    -- packagemanager, kept optional as it's bootstrapped in init.lua
    use {'wbthomason/packer.nvim', opt = true}

    -- widely used shared plugins
    use {'nvim-lua/popup.nvim'}
    use {'nvim-lua/plenary.nvim'}

    -- treesitter
    use {'david-kunz/treesitter-unit'}
    use {'nvim-treesitter/nvim-treesitter'}

    -- telescope
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
    use {'neovim/nvim-lsp'}

    -- debugging
    use {'sakhnik/nvim-gdb', run = './install.sh' }

    -- misc utilities
    use {'andymass/vim-matchup'}
    use {'kevinhwang91/nvim-bqf'}
    use {'ggandor/lightspeed.nvim'}
    use {'rcarriga/nvim-notify'}
    use {'steelsojka/pears.nvim'}
    use {'tpope/vim-surround'}
    use {'tpope/vim-commentary'}
    use {'mbbill/undotree'}
    use {'christoomey/vim-tmux-navigator'}
    use {'andersevenrud/cmp-tmux'}
    use {'kabbamine/zeavim.vim'}
    use {'theprimeagen/harpoon'}

    -- theme
    use {'nvim-lualine/lualine.nvim', requires = {{'kyazdani42/nvim-web-devicons'}}}
    use {'mofiqul/dracula.nvim'}

    -- git
    use {'lewis6991/gitsigns.nvim'}
    use {'theprimeagen/git-worktree.nvim'}
    use {'rhysd/git-messenger.vim'}
    use {'tpope/vim-fugitive'}
end)
m.keys_for_filetype{
    {'fugitive', 'n', 'q', 'gq'},
    {'fugitiveblame', 'n', 'q', 'gq'},

    {'git', 'n', 'q', '<cmd>q<cr>'}
}

m.keys{
    {'n', '<leader>gs', [[<cmd>G<cr>]]},
    {'n', '<leader>gb', [[<cmd>G blame<cr>]]},
    {'n', '<leader>gll', [[<cmd>Gclog<cr>]]},
    {'n', '<leader>glf', [[<cmd>Gclog %<cr>]]},
    {'n', '<leader>gm', [[<cmd>GitMessenger<cr>]]},
}

-- lsp
local cmp = require('cmp')
local client_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn['UltiSnips#Anon'](args.body)
        end
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'buffer'},
        { name = 'path'},
        { name = 'treesitter'},
        { name = 'tmux'}
    }
}

local nvim_lsp = require('lspconfig')
-- clangd and lua are handled externally
local lsps = {
    'cmake',
    'gopls',
    'pylsp',
    'rust_analyzer',
    'tsserver',
}

-- disable virtual text
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
    {
        update_in_insert = true,
        virtual_text = false
    })
-- show diagnostics in floating window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

local function on_init(client)
    client.config.flags.debounce_text_change = 150
end


for _, lsp in ipairs(lsps) do
    nvim_lsp[lsp].setup {
        capabilities = client_capabilities,
        on_init = on_init
    }
end

-- clangd
nvim_lsp.clangd.setup {
    cmd = {"clangd",
        "--header-insertion=never",
        "--all-scopes-completion",
        "--background-index",
        "--clang-tidy",
        "--cross-file-rename",
        "--suggest-missing-includes",
        "--log=verbose"
    },
    capabilities = client_capabilities,
    on_init = on_init
}

-- lua lsp, because it's its own special snowflake
nvim_lsp.sumneko_lua.setup {
    cmd = {"lua-language-server"},
    settings = {
        Lua = {
            diagnostics = {
                globals = {'vim'} -- Ignore missing vim global which is injected
            }
        }
    },
    capabilities = client_capabilities,
    on_init = on_init
}

m.keys{
    {'n', 'gd', [[<cmd>lua vim.lsp.buf.definition()<CR>]]},
    {'n', '<leader>ri', [[<cmd>lua vim.lsp.buf.implementation()<CR>]]},
    {'n', '<leader>rs', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]]},
    {'n', '<leader>rr', [[<cmd>lua vim.lsp.buf.references()<CR>]]},
    {'n', '<leader>ro', [[<cmd>lua vim.lsp.buf.rename()<CR>]]},
    {'n', '<leader>rh', [[<cmd>lua vim.lsp.buf.hover()<CR>]]},
    {'n', '<leader>re', [[<cmd>lua vim.lsp.buf.code_action()<CR>]]},
    {'n', '<leader>rn', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]]},
    {'n', '<leader>rq', [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR> ]]}
}

-- tmux
vim.g.tmux_navigator_no_mappings = 1
m.keys {
    {'n', '<C-h>', [[<cmd>TmuxNavigateLeft<cr>]]},
    {'n', '<C-j>', [[<cmd>TmuxNavigateDown<cr>]]},
    {'n', '<C-k>', [[<cmd>TmuxNavigateUp<cr>]]},
    {'n', '<C-l>', [[<cmd>TmuxNavigateRight<cr>]]}
}

-- harpoon
require('harpoon').setup()
m.keys {
    {'n', '<M-a>', [[<cmd>lua require('harpoon.mark').add_file()<cr>]]},
    {'n', '<M-s>', [[<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>]]},
    {'n', '<M-j>', [[<cmd>lua require('harpoon.ui').nav_file(1)<cr>]]},
    {'n', '<M-k>', [[<cmd>lua require('harpoon.ui').nav_file(2)<cr>]]},
    {'n', '<M-l>', [[<cmd>lua require('harpoon.ui').nav_file(3)<cr>]]},
    {'n', '<M-;>', [[<cmd>lua require('harpoon.ui').nav_file(4)<cr>]]},

    {'n', '<M-c>', [[<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<cr>]]},
    {'n', '<M-b>', [[<cmd>lua require('harpoon.tmux').sendCommand(1, 1)<cr>]]},
}

-- telescope extensions
local ts = require('telescope')
ts.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
ts.load_extension('git_worktree')
ts.load_extension('notify')
ts.load_extension('fzf')

m.keys{ -- regular keybinds
    {'n', '<leader>fd', [[<cmd>Telescope file_browser<cr>]]},
    {'n', '<leader>ff', [[<cmd>Telescope find_files<cr>]]},
    {'n', '<leader>fg', [[<cmd>Telescope live_grep<cr>]]},
    {'n', '<leader>fr', [[<cmd>Telescope grep_string<cr>]]},
    {'n', '<leader>fe', [[<cmd>e ~/.config/nvim/init.lua<cr>]]},
    {'n', '<leader>b', [[<cmd>Telescope buffers<cr>]]},
    {'n', '<leader>gb', [[<cmd>Telescope git_branches<cr>]]},
    {'n', '<leader>h', [[<cmd>Telescope help_tags<cr>]]}
}

m.keys{ -- extensions
    {'n', '<leader>gw', [[<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>]]},
    {'n', '<leader>gtc', [[<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>]]},
}

-- treesitter
require('nvim-treesitter.configs').setup({
    -- Don't do the following without internet
    ensure_installed = 'maintained',
    -- enable all the treesitter features
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = true },
    matchup = { enable = true },
})

m.keys {
    {'x', 'iu', [[:lua require('treesitter-unit').select()<cr>]]},
    {'x', 'au', [[:lua require('treesitter-unit').select(true)<cr>]]},
    {'o', 'iu', [[:<c-u>lua require('treesitter-unit').select()<cr>]]},
    {'o', 'au', [[:<c-u>lua require('treesitter-unit').select(true)<cr>]]},
}

-- theme
local function lualine_or_tmux_git()
    if (os.getenv("TMUX") == nil) then
        local file = io.popen('git branch --show', 'r')
        local res = file:read()
        file:close()
        return res
    else
        return ''
    end
end

local function relative_file_name()
    return vim.fn.expand('%')
end

-- lualine setup
require('lualine').setup({
    options = { 
        theme = 'dracula-nvim',
        icons_enabled = true,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {lualine_or_tmux_git},
        lualine_c = {relative_file_name},
        lualine_x = {'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    interactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
})

vim.g.dracula_transparent_bg = true
vim.g.dracula_lualine_bg_color = "#44475a"
vim.g.dracula_show_end_of_buffer = true
vim.cmd('colorscheme dracula')

-- notify
vim.notify = require('notify')

-- pears
require('pears').setup()

-- vim commentary
m.keys {
    {'v', '<leader>a', [[:'<,'>Commentary<cr>]]},
    {'n', '<leader>a', [[:Commentary<cr>]]},
}

-- undotree
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SetFocusWhenToggle = true
m.key('n', 'U', [[<cmd>UndotreeToggle<cr>]])

-- git
require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 500,
    }
})

