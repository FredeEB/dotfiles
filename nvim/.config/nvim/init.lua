
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
    {'v', '<leader>p', '"+p'},
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
    {'n', '<leader>fe', [[<cmd>e ~/.config/nvim/init.lua<cr>]] },
    {'n', 'n', [[nzzzv]]},
    {'n', 'N', [[Nzzzv]]},
    {'n', 'J', [[mzJ`z]]},
}

-- bootstrap packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.api.nvim_command('packadd packer.nvim')
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
    use {"nvim-telescope/telescope-file-browser.nvim"}

    -- snippets
    use {'dawikur/algorithm-mnemonics.vim'}
    use {'dcampos/nvim-snippy'}
    use {'dcampos/cmp-snippy'}
    use {'honza/vim-snippets'}

    -- cmp
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-path'}
    use {'ray-x/cmp-treesitter'}
    use {'andersevenrud/cmp-tmux'}
    use {'hrsh7th/nvim-cmp'}

    -- lsp
    use {'neovim/nvim-lsp'}
    use {'ray-x/lsp_signature.nvim'}

    -- debugging
    use {'sakhnik/nvim-gdb', run = './install.sh' }

    -- misc utilities
    use {'windwp/nvim-autopairs'}
    use {'tpope/vim-surround'}
    use {'numtostr/comment.nvim'}
    use {'mbbill/undotree'}
    use {'aserowy/tmux.nvim'}
    use {'kabbamine/zeavim.vim'}
    use {'theprimeagen/harpoon'}
    use {'mickael-menu/zk-nvim'}

    -- theme
    use {'nvim-lualine/lualine.nvim', requires = {{'kyazdani42/nvim-web-devicons'}}}
    use {'mofiqul/dracula.nvim'}

    -- git
    use {'lewis6991/gitsigns.nvim'}
    use {'theprimeagen/git-worktree.nvim'}
end)


require('tmux').setup {
    copy_sync = {
        enable = true,
    },
    navigation = {
        enable_default_keybindings = true,
    },
}

-- cmp
local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args) require('snippy').expand_snippet(args.body) end
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp', max_item_count = 10 },
        { name = 'snippy', max_item_count = 5 },
        { name = 'buffer', max_item_count = 5 },
        { name = 'path', max_item_count = 5 },
        { name = 'treesitter', max_item_count = 5 },
        { name = 'tmux', max_item_count = 5 }
    }
}

-- snippets
require('snippy').setup {
    mappings = {
        is = {
            ["<C-j>"] = "expand_or_advance",
            ["<C-k>"] = "previous",
        },
        nx = {
            ["<leader>"] = "cut_text",
        },
    },
}

-- lsp
local nvim_lsp = require('lspconfig')
require('lsp_signature').setup()

-- disable virtual text
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
    {
        update_in_insert = true,
        virtual_text = false
    })
-- show diagnostics in floating window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="line"})]]

local function on_init(client)
    client.config.flags.debounce_text_change = 150
end

local client_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- clangd and lua are handled externally
for _, lsp in ipairs {'cmake', 'gopls', 'pylsp', 'rust_analyzer', 'tsserver', 'zls'} do
    nvim_lsp[lsp].setup {
        capabilities = client_capabilities,
        on_init = on_init
    }
end

-- clangd
nvim_lsp.clangd.setup {
    cmd = {
        "clangd",
        "--header-insertion=never",
        "--all-scopes-completion",
        "--background-index",
        "--clang-tidy",
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
    {'n', 'gd', vim.lsp.buf.definition },
    {'n', '<leader>ri', vim.lsp.buf.implementation },
    {'n', '<leader>rs', vim.lsp.buf.signature_help },
    {'n', '<leader>rr', vim.lsp.buf.references },
    {'n', '<leader>ro', vim.lsp.buf.rename },
    {'n', '<leader>rh', vim.lsp.buf.hover },
    {'n', '<leader>re', vim.lsp.buf.code_action },
    {'n', '<leader>rn', vim.lsp.diagnostic.goto_next },
}

-- harpoon
require('harpoon').setup()
m.keys {
    {'n', '<M-a>', function() require('harpoon.mark').add_file() end },
    {'n', '<M-s>', function() require('harpoon.ui').toggle_quick_menu() end },
    {'n', '<M-j>', function() require('harpoon.ui').nav_file(1) end },
    {'n', '<M-k>', function() require('harpoon.ui').nav_file(2) end },
    {'n', '<M-l>', function() require('harpoon.ui').nav_file(3) end },
    {'n', '<M-;>', function() require('harpoon.ui').nav_file(4) end },
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
    },
    pickers = {
        find_files = {
            hidden = true,
            file_ignore_patterns = {".git"}
        }
    },
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--hidden',
            '--ignore',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--trim',
            '--smart-case'
        },
    }
}
ts.load_extension('git_worktree')
ts.load_extension('fzf')
ts.load_extension('file_browser')

-- zk
require('zk').setup()
ts.load_extension('zk')

m.keys{ -- telescope
    {'n', '<leader>ff', function() require('telescope.builtin').find_files() end },
    {'n', '<leader>fg', function() require('telescope.builtin').live_grep() end },
    {'n', '<leader>fr', function() require('telescope.builtin').grep_string() end },
    {'n', '<leader>b', function() require('telescope.builtin').buffers() end },
    {'n', '<leader>gb', function() require('telescope.builtin').git_branches() end },
    {'n', '<leader>h', function() require('telescope.builtin').help_tags() end }
}

m.keys{ -- extensions
    {'n', '<leader>fd', function() require('telescope').extensions.file_browser.file_browser() end },
    {'n', '<leader>gw', function() require('telescope').extensions.git_worktree.git_worktrees() end },
    {'n', '<leader>gtc', function() require('telescope').extensions.git_worktree.create_git_worktree() end },
}

local notes_path = vim.fn.expand('$HOME') .. '/git/notes'

m.keys{
    {'n', '<leader>zi', function() require('zk').index(nil, { dir = notes_path }) end },
    {'n', '<leader>zn', function() require('zk').new(nil, { dir = notes_path }) end },
    {'v', '<leader>zn', function() require('zk').new_link(nil, { dir = notes_path }) end },
    {'n', '<leader>zl', function() require('zk').list(nil, { dir = notes_path }) end },
}

-- treesitter
require('nvim-treesitter.configs').setup({
    -- Don't do the following without internet
    ensure_installed = 'maintained',
    -- enable all the treesitter features
    highlight = { enable = true },
    incremental_selection = { enable = true },
    matchup = { enable = true },
})

m.keys {
    {'x', 'iu', function() require('treesitter-unit').select() end },
    {'x', 'au', function() require('treesitter-unit').select(true) end },
    {'o', 'iu', function() require('treesitter-unit').select() end },
    {'o', 'au', function() require('treesitter-unit').select(true) end },
}

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
        lualine_b = {},
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

vim.g.dracula_lualine_bg_color = "#44475a"
vim.g.dracula_show_end_of_buffer = true
vim.cmd('colorscheme dracula')

-- autopairs
require('nvim-autopairs').setup {
    check_ts = true,
}

-- comments
require("Comment").setup{}

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

m.keys{
    {'n', '<leader>gq', require('gitsigns').setqflist },
    {'n', '<leader>gA', require('gitsigns').stage_buffer },
    {'n', '<leader>gR', require('gitsigns').reset_buffer },
    {{'n','v'}, '<leader>ga', require('gitsigns').stage_hunk },
    {{'n','v'}, '<leader>gr', require('gitsigns').reset_hunk },
    {'n', '<leader>gu', require('gitsigns').undo_stage_hunk },
    {'n', '<leader>gp', require('gitsigns').preview_hunk },
    {'n', '<leader>gd', require('gitsigns').diffthis },
    {'n', '<leader>gm', require('gitsigns').blame_line },
    {'n', '<leader>gs', require('telescope.builtin').git_status }
}
