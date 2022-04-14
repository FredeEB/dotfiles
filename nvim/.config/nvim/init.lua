
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

m.keys { -- undo tags
    { 'i', ',', [[<C-g>u,]] },
    { 'i', '.', [[<C-g>u.]] },
    { 'i', '!', [[<C-g>u!]] },
    { 'i', '?', [[<C-g>u?]] },
    { 'i', ';', [[<C-g>u;]] },
}

m.keys { -- vblock moves
    { 'v', 'K', [[:m '<-2<cr>gv=gv]] },
    { 'v', 'J', [[:m '>+1<cr>gv=gv]] },
}

m.keys { -- closing files
    { 'n', '<leader>q', [[<cmd>q<cr>]] },
    { 'n', '<leader>Q', [[<cmd>q!<cr>]] },
}

m.keys { -- tmux
    { 'n', '<leader>t', [[<cmd>!tmux split-window -h -c %:p:h<cr><cmd>redraw!<cr>]] },
    { 'n', '<leader>gr', [[<cmd>!tmux split-window -h -c `git rev-parse --show-toplevel`<cr><cmd>redraw!<cr>]] }
}

m.keys { -- qfl
    { 'n', '<C-p>', [[<cmd>cprev<cr>]] },
    { 'n', '<C-n>', [[<cmd>cnext<cr>]] },
    { 'n', '<C-q>', [[<cmd>copen<cr>]] },
    { 'n', '<C-c>', [[<cmd>lclose | cclose<cr>]] },
    { 'n', '<M-p>', [[<cmd>lprev<cr>]] },
    { 'n', '<M-n>', [[<cmd>lnext<cr>]] },
    { 'n', '<M-q>', [[<cmd>lopen<cr>]] },
    { 'n', '<leader>l', [[<cmd>lvim // % | lopen<cr>]] }
}

m.keys { -- misc
    { 'n', '<leader>fd', [[<cmd>Explore<cr>]] },
    { 'n', '<leader>fe', [[<cmd>!tmux new-window -c ~ -n nvim-conf 'nvim ~/.config/nvim/init.lua'<cr><cmd>redraw!<cr>]] },
    { 'n', 'n', [[nzzzv]] },
    { 'n', 'N', [[Nzzzv]] },
    { 'n', 'J', [[mzJ`z]] },
}

-- bootstrap packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.api.nvim_command('packadd packer.nvim')
end

vim.cmd('packadd packer.nvim')
-- autoload file when it changes
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'PackerCompile',
    pattern = vim.fn.stdpath('config') .. 'init.lua'
})
-- close vim if only the qfl is open
vim.api.nvim_create_autocmd('WinEnter', {
    command = [[ if winnr('$') == 1 && &buftype == 'quickfix' | q | endif ]]
})

require('packer').startup(function(use)
    -- packagemanager, kept optional as it's bootstrapped in init.lua
    use { 'wbthomason/packer.nvim', opt = true }

    -- widely used shared plugins
    use { 'nvim-lua/popup.nvim' }
    use { 'nvim-lua/plenary.nvim' }

    -- treesitter
    use { 'david-kunz/treesitter-unit' }
    use { 'nvim-treesitter/nvim-treesitter', run = require('nvim-treesitter.install').update }

    -- telescope
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope.nvim' }

    -- snippets
    use { 'dawikur/algorithm-mnemonics.vim' }
    use { 'dcampos/nvim-snippy' }
    use { 'dcampos/cmp-snippy' }
    use { 'honza/vim-snippets' }

    -- cmp
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-path' }
    use { 'andersevenrud/cmp-tmux' }
    use { 'hrsh7th/nvim-cmp' }

    -- lsp
    use { 'neovim/nvim-lsp' }
    use { 'ray-x/lsp_signature.nvim' }

    -- debugging
    use {'sakhnik/nvim-gdb', run = './install.sh' }

    -- misc utilities
    use { 'windwp/nvim-autopairs' }
    use { 'tpope/vim-surround' }
    use { 'numtostr/comment.nvim' }
    use { 'mbbill/undotree' }
    use { 'aserowy/tmux.nvim' }
    use { 'kabbamine/zeavim.vim' }
    use { 'theprimeagen/harpoon' }
    use { 'tversteeg/registers.nvim' }
    use { 'olimorris/persisted.nvim' }
    use { 'ggandor/leap.nvim' }

    -- theme
    use { 'nvim-lualine/lualine.nvim', requires = { { 'kyazdani42/nvim-web-devicons' } } }
    use { 'mofiqul/dracula.nvim' }

    -- git
    use { 'lewis6991/gitsigns.nvim' }
    use { 'sindrets/diffview.nvim' }
    use { 'theprimeagen/git-worktree.nvim' }
end)


require('tmux').setup {
    copy_sync = {
        enable = true,
        redirect_to_clipboard = true,
    },
    navigation = {
        enable_default_keybindings = true,
    },
}

-- terminal config
m.keys {
    { 't', '<C-h>', '<C-\\><C-N><C-w>h' },
    { 't', '<C-j>', '<C-\\><C-N><C-w>j' },
    { 't', '<C-k>', '<C-\\><C-N><C-w>k' },
    { 't', '<C-l>', '<C-\\><C-N><C-w>l' },
}

-- start terminal in insert mode
vim.api.nvim_create_autocmd('TermOpen', {
    command = 'startinsert'
})
-- close terminal buffer after command finishes
vim.api.nvim_create_autocmd('TermClose', {
    command = 'bdelete'
})

require('leap').set_default_keymaps()

-- cmp
local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args) require('snippy').expand_snippet(args.body) end
    },
    mapping = cmp.mapping.preset.insert(
        {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
        { name = 'nvim_lsp', max_item_count = 20, priority = 0 },
        { name = 'snippy', max_item_count = 10, priority = 1 },
        { name = 'buffer', max_item_count = 10, priority = 2 },
        { name = 'path', max_item_count = 10, priority = 3 },
        { name = 'tmux', max_item_count = 10, priority = 4 }
    }
}

-- snippets
require('snippy').setup {
    mappings = {
        is = {
            ['<C-j>'] = 'expand_or_advance',
            ['<C-k>'] = 'previous',
        },
        nx = {
            ['<leader>'] = 'cut_text',
        },
    },
}

-- lsp
local nvim_lsp = require('lspconfig')
require('lsp_signature').setup()

-- disable virtual text
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
    {
        update_in_insert = true,
        virtual_text = false
    })
-- show diagnostics in floating window
vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    callback = function() vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' }) end
})

local function on_init(client)
    client.config.flags.debounce_text_change = 150
end

local client_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- clangd and lua are handled externally
for _, lsp in ipairs { 'cmake', 'gopls', 'pylsp', 'rust_analyzer', 'tsserver', 'zls' } do
    nvim_lsp[lsp].setup {
        capabilities = client_capabilities,
        on_init = on_init
    }
end

-- clangd
nvim_lsp.clangd.setup {
    cmd = {
        'clangd',
        '--header-insertion=never',
        '--all-scopes-completion',
        '--background-index',
        '--clang-tidy',
    },
    capabilities = client_capabilities,
    on_init = on_init
}

-- lua lsp, because it's its own special snowflake
nvim_lsp.sumneko_lua.setup {
    cmd = { 'lua-language-server' },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' } -- Ignore missing vim global which is injected
            }
        }
    },
    capabilities = client_capabilities,
    on_init = on_init
}

m.keys {
    { 'n', 'gd', vim.lsp.buf.definition },
    { 'n', '<leader>ri', vim.lsp.buf.implementation },
    { 'n', '<leader>rs', vim.lsp.buf.signature_help },
    { 'n', '<leader>rr', vim.lsp.buf.references },
    { 'n', '<leader>ro', vim.lsp.buf.rename },
    { 'n', '<leader>rh', vim.lsp.buf.hover },
    { 'n', '<leader>re', vim.lsp.buf.code_action },
    { 'n', '<leader>rn', vim.diagnostic.goto_next },
    { 'n', '<leader>rp', vim.diagnostic.goto_prev },
    { 'n', '<leader>rd', vim.diagnostic.setloclist },
    { 'n', '<leader>rf', vim.lsp.buf.formatting },
    { 'v', '<leader>rf', vim.lsp.buf.range_formatting },
}

-- harpoon
require('harpoon').setup()
m.keys {
    { 'n', '<M-a>', require('harpoon.mark').add_file },
    { 'n', '<M-s>', require('harpoon.ui').toggle_quick_menu },
    { 'n', '<M-j>', function() require('harpoon.ui').nav_file(1) end },
    { 'n', '<M-k>', function() require('harpoon.ui').nav_file(2) end },
    { 'n', '<M-l>', function() require('harpoon.ui').nav_file(3) end },
    { 'n', '<M-;>', function() require('harpoon.ui').nav_file(4) end },
}

-- telescope extensions
local ts = require('telescope')
ts.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = 'smart_case',
        }
    },
    pickers = {
        find_files = {
            hidden = true,
            file_ignore_patterns = { '.git', '.clangd', 'node_modules' }
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

m.keys { -- telescope
    { 'n', '<leader>ff', require('telescope.builtin').find_files },
    { 'n', '<leader>fg', require('telescope.builtin').live_grep },
    { 'n', '<leader>fr', require('telescope.builtin').grep_string },
    { 'n', '<leader>b', require('telescope.builtin').buffers },
    { 'n', '<leader>gb', require('telescope.builtin').git_branches },
    { 'n', '<leader>h', require('telescope.builtin').help_tags }
}


m.keys { -- extensions
    { 'n', '<leader>gw', require('telescope').extensions.git_worktree.git_worktrees },
    { 'n', '<leader>gtc', require('telescope').extensions.git_worktree.create_git_worktree },
}

-- treesitter
require('nvim-treesitter.configs').setup({
    -- Don't do the following without internet
    ensure_installed = 'all',
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    matchup = { enable = true },
})

m.keys {
    { { 'x', 'o' }, 'iu', require('treesitter-unit').select },
    { { 'x', 'o' }, 'au', function() require('treesitter-unit').select(true) end },
}

require('persisted').setup {
    dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
    use_git_branch = true,
    options = { "buffers", "curdir", "tabpages", "winsize" },
}

m.keys {
    { 'n', '<leader>as', require('persisted').load },
    { 'n', '<leader>ad', require('persisted').stop },
}

-- lualine setup
local function relative_file_name()
    return vim.fn.expand('%')
end

require('lualine').setup({
    options = {
        theme = 'dracula',
        icons_enabled = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {},
        lualine_c = { relative_file_name },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    interactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
})

vim.g.dracula_lualine_bg_color = '#44475a'
vim.g.dracula_show_end_of_buffer = true
vim.cmd('colorscheme dracula')

-- autopairs
require('nvim-autopairs').setup {
    check_ts = true,
}

-- comments
require('Comment').setup {}

-- undotree
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SetFocusWhenToggle = true
m.key('n', 'U', [[<cmd>UndotreeToggle<cr>]])

-- git
require('gitsigns').setup({
    current_line_blame = false,
    current_line_blame_opts = {
        delay = 500,
    }
})

m.keys {
    { 'n', '<leader>gq', require('gitsigns').setqflist },
    { 'n', '<leader>gA', require('gitsigns').stage_buffer },
    { 'n', '<leader>gR', require('gitsigns').reset_buffer },
    { { 'n', 'v' }, '<leader>ga', require('gitsigns').stage_hunk },
    { { 'n', 'v' }, '<leader>gr', require('gitsigns').reset_hunk },
    { 'n', '<leader>gu', require('gitsigns').undo_stage_hunk },
    { 'n', '<leader>gp', require('gitsigns').preview_hunk },
    { 'n', '<leader>gd', require('diffview').open },
    { 'n', '<leader>gm', require('gitsigns').blame_line },
    { 'n', '<leader>gs', require('telescope.builtin').git_status }
}

m.keys_for_filetype {
    { 'DiffviewFiles', 'n', 'q', '<cmd>DiffviewClose<cr>' },
    { 'DiffviewFileHistory', 'n', 'q', '<cmd>DiffviewClose<cr>' },
}
