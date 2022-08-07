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
vim.o.laststatus = 3
vim.o.inccommand = 'nosplit'
vim.o.termguicolors = true
vim.o.fixeol = false
vim.o.signcolumn = 'yes:1'

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
    { 'n', '<leader>q', [[<cmd>bdelete<cr>]] },
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

local function open_config()
    local config_buf = vim.api.nvim_create_buf(true, true)
    local config_path = vim.fn.stdpath('config') .. '/init.lua'
    local function reload_config()
        vim.cmd('source ' .. config_path)
    end
    local augrp = vim.api.nvim_create_augroup('ConfigEdit', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePost', {
        group = 'ConfigEdit',
        buffer = config_buf,
        callback = reload_config
    })
    vim.api.nvim_create_autocmd('BufDelete', {
        group = 'ConfigEdit',
        buffer = config_buf,
        callback = function()
            reload_config()
            vim.api.nvim_del_augroup_by_id(augrp)
        end
    })

    vim.api.nvim_set_current_buf(config_buf)
    vim.cmd('e ' .. config_path)
    vim.cmd('lcd %:h')
end

-- autoload file when it changes
vim.api.nvim_create_augroup('Config', { clear = true })
--[[ vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'Config',
    pattern = {'*.cpp', '*.hpp', '*.c', '*.h'},
    callback = function()
        vim.lsp.buf.format { async = true }
    end
})
]]
vim.api.nvim_create_autocmd('BufWritePost', {
    group = 'Config',
    pattern = 'init.lua',
    callback = function()
        vim.cmd('source <afile>')
        require('packer').compile()
    end
})

m.keys { -- misc
    { 'n', '<leader>fd', [[<cmd>Explore<cr>]] },
    { 'n', '<leader>fe', open_config },
    { 'n', 'n', [[nzzzv]] },
    { 'n', 'N', [[Nzzzv]] },
    { 'n', 'J', [[mzJ`z]] },
}

-- bootstrap packer
local packer_bootstrap = false
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

local packer = require('packer')
packer.startup(function(use)

    use { 'wbthomason/packer.nvim' }

    -- common
    use { 'nvim-lua/popup.nvim' }
    use { 'nvim-lua/plenary.nvim' }
    -- tmux
    use { 'aserowy/tmux.nvim' }
    use { 'shivamashtikar/tmuxjump.vim' }
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
    use { 'olimorris/persisted.nvim' }
    use { 'windwp/nvim-autopairs' }
    use { 'terrortylor/nvim-comment', config = function() require('nvim_comment').setup() end }
    use { 'mbbill/undotree' }
    use { 'kabbamine/zeavim.vim' }
    use { 'tversteeg/registers.nvim' }
    use { 'anuvyklack/hydra.nvim', requires = { 'anuvyklack/keymap-layer.nvim' } }
    use { 'lewis6991/spellsitter.nvim', config = function() require('spellsitter').setup() end }

    if packer_bootstrap == true then
        packer.sync()
    end

end)

local hydra = require('hydra')

-- close vim if only the qfl is open
vim.api.nvim_create_autocmd('WinEnter', {
    command = [[if winnr('$') == 1 && &buftype == 'quickfix' | q | endif]]
})

vim.notify = function(msg, level, opts)
    if vim.env.SSH_TTY == not nil then
        require('notify')(msg, level, opts)
    else
        io.popen('notify-send Neovim "' .. msg .. '"'):close()
    end
end

-- tmux
require('tmux').setup {
    copy_sync = {
        enable = true,
        redirect_to_clipboard = true,
    },
    navigation = {
        enable_default_keybindings = true,
    },
}

vim.g.tmuxjump_telescope = true
m.keys {
    { 'n', '<leader>;', '<cmd>TmuxJumpFile<cr>' }
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
    command = 'startinsert',
    group = 'Config'
})
-- close terminal buffer after command finishes
vim.api.nvim_create_autocmd('TermClose', {
    command = 'bdelete',
    group = 'Config'
})

-- snippets
require('luasnip.loaders.from_snipmate').lazy_load()
local ls = require('luasnip')
m.keys({
    { { 'i', 's' }, "<C-j>", function () if ls.expand_or_jumpable() then ls.expand_or_jump() end end },
    { { 'i', 's' }, "<C-k>", function () if ls.expand_or_jumpable(-1) then ls.expand_or_jump(-1) end end },
    { { 'i', 's' }, "<C-l>", function () if ls.choice_active() then ls.change_choice(1) end end } },
    { silent = true }
)

-- cmp
local cmp = require('cmp')

cmp.setup {
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp', max_item_count = 20, priority = 10 },
        { name = 'luasnip', max_item_count = 20, priority = 10 },
        { name = 'buffer', max_item_count = 10, priority = 3 },
        { name = 'path', max_item_count = 10, priority = 3 },
    }
}

-- lsp
local nvim_lsp = require('lspconfig')

-- disable virtual text
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
    { update_in_insert = true, virtual_text = false })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, { border = "single" })
-- show diagnostics in floating window
vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    callback = function() vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' }) end,
    group = 'Config'
})

local function on_init(client)
    client.config.flags.debounce_text_change = 150
end

local client_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- clangd and lua are handled externally
for _, lsp in ipairs { 'cmake', 'dartls', 'gopls', 'pylsp', 'rust_analyzer', 'tsserver', 'zls' } do
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
    { 'n', '<leader>rs', vim.lsp.buf.signature_help },
    { 'n', '<leader>rr', [[<cmd>Telescope lsp_references<cr>]] },
    { 'n', '<leader>ro', vim.lsp.buf.rename },
    { 'n', '<leader>rh', vim.lsp.buf.hover },
    { 'n', '<leader>re', vim.lsp.buf.code_action },
    { 'n', '<leader>rn', vim.diagnostic.goto_next },
    { 'n', '<leader>rp', vim.diagnostic.goto_prev },
    { 'n', '<leader>rd', vim.diagnostic.setloclist },
    { 'n', '<leader>rf', function() vim.lsp.buf.format { async = true } end },
    { 'v', '<leader>rf', vim.lsp.buf.range_formatting },
}

-- dap
local dap = require('dap')
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/local/bin/lldb-vscode',
    name = 'lldb'
}

dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopOneEntry = false,
        args = function()
            local args = vim.fn.input('Args: ')
            return vim.fn.split(args, ' ')
        end,
    }
}

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

hydra({
    name = 'Dap Debug',
    config = {
        foreign_keys = 'run',
        exit = false,
        invoke_on_body = true,
    },
    mode = { 'n', 'x' },
    body = '<leader>d',
    heads = {
        { 'c', require('dap').continues, { desc = 'continue' } },
        { 'b', require('dap').toggle_breakpoint, { desc = 'toggle breakpoint' } },
        { 's', require('dap').step_over, { desc = 'step over' } },
        { 'i', require('dap').step_into, { desc = 'step into' } },
        { 'q', function()
            require('dap').close()
            require('dapui').close()
        end, { desc = 'stop' } },
    }
})

-- harpoon
require('harpoon').setup {
    global_settings = {
        enter_on_sendcmd = true,
        tmux_autoclose_windows = true,
    }
}
m.keys {
    { 'n', '<M-a>', require('harpoon.mark').add_file },
    { 'n', '<M-s>', require('harpoon.ui').toggle_quick_menu },
    { 'n', '<M-j>', function() require('harpoon.ui').nav_file(1) end },
    { 'n', '<M-k>', function() require('harpoon.ui').nav_file(2) end },
    { 'n', '<M-l>', function() require('harpoon.ui').nav_file(3) end },
    { 'n', '<M-;>', function() require('harpoon.ui').nav_file(4) end },
    { 'n', '<M-c>', require('harpoon.cmd-ui').toggle_quick_menu },
    -- send to adjacent pane
    { 'n', '<M-b>', function() require('harpoon.tmux').sendCommand('+', 1) end },
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
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    matchup = { enable = true },
})

-- tree-climber/hopper
m.keys {
    { { 'x', 'o' }, 'iu', require('treesitter-unit').select },
    { { 'x', 'o' }, 'au', function() require('treesitter-unit').select(true) end },
    { { 'v', 'o' }, 'm', require('tsht').nodes, { remap = false } },
    { 'n', 'H', require('tree-climber').goto_parent },
    { 'n', 'L', require('tree-climber').goto_child },
}

-- sessions
require('persisted').setup {
    dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
    use_git_branch = true,
}
vim.o.sessionoptions = "buffers,curdir,tabpages,winsize"

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
        lualine_y = { 'branch' },
        lualine_z = { 'location' },
    },
    interactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { 'filename' },
        lualine_y = { 'branch' },
        lualine_z = { 'location' },
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

require('neogit').setup {
    use_magit_keybinds = true,
    integrations = {
        diffview = true
    },
    disable_builtin_notifications = true,
    disable_commit_confirmation = true,
}

m.keys {
    { 'n', '<leader>gq', require('gitsigns').setqflist },
    { 'n', '<leader>gA', require('gitsigns').stage_buffer },
    { 'n', '<leader>gR', require('gitsigns').reset_buffer },
    { { 'n', 'v' }, '<leader>ga', require('gitsigns').stage_hunk },
    { { 'n', 'v' }, '<leader>gr', require('gitsigns').reset_hunk },
    { 'n', '<leader>gu', require('gitsigns').undo_stage_hunk },
    { 'n', '<leader>gp', require('gitsigns').preview_hunk },
    { 'n', '<leader>gd', require('diffview').open },
    { 'n', '<leader>gm', function() require('gitsigns').blame_line{ full = true } end },
    { 'n', '<leader>gs', require('neogit').open },
}

m.keys_for_filetype {
    { 'DiffviewFiles', 'n', 'q', '<cmd>DiffviewClose<cr>' },
    { 'DiffviewFileHistory', 'n', 'q', '<cmd>DiffviewClose<cr>' },
}
