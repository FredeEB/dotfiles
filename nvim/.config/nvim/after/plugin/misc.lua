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
vim.o.guifont = 'Iosevka Nerd Font:h10'
vim.o.mousemodel = 'extend'

local m = require('functions.keymap')

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

m.keys {
    { 'n', '<C-h>', '<C-w>h' },
    { 'n', '<C-j>', '<C-w>j' },
    { 'n', '<C-k>', '<C-w>k' },
    { 'n', '<C-l>', '<C-w>l' },
}

m.keys { -- closing files
    { 'n', '<leader>q', [[<cmd>bw<cr>]] },
    { 'n', '<leader>Q', [[<cmd>q!<cr>]] },
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
end

-- autoload file when it changes
vim.api.nvim_create_augroup('Config', { clear = true })
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
    { 'n', '<leader><leader>', [[<cmd>e term:///bin/bash<cr>]] },
    { 'n', '<leader>j', [[<cmd>vsplit term:///bin/bash<cr>]] },
    { 'n', '<leader>k', [[<cmd>split term:///bin/bash<cr>]] },
}


-- close vim if only the qfl is open
vim.api.nvim_create_autocmd('WinEnter', {
    command = [[if winnr('$') == 1 && &buftype == 'quickfix' | q | endif]]
})

vim.notify = function(msg, level, opts)
    if vim.env.SSH_TTY == nil and vim.fn.executable('notify-send') == 1 then
        io.popen('notify-send Neovim "' .. msg .. '"'):close()
    else
        require('notify')(msg, level, opts)
    end
end

-- osc52
local function copy(lines, _)
    require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
    return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
end

vim.g.clipboard = {
    name = 'osc52',
    copy = { ['+'] = copy, ['*'] = copy },
    paste = { ['+'] = paste, ['*'] = paste },
}

-- Now the '+' register will copy to system clipboard using OSC52
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true })
vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
vim.keymap.set('x', '<leader>c', require('osc52').copy_visual)

-- terminal config
vim.o.scrollback = 100000

m.keys {
    { 't', '<C-h>', '<C-\\><C-N><C-w>h' },
    { 't', '<C-j>', '<C-\\><C-N><C-w>j' },
    { 't', '<C-k>', '<C-\\><C-N><C-w>k' },
    { 't', '<C-l>', '<C-\\><C-N><C-w>l' },
    { 't', '<esc>', '<C-\\><C-n>' },
}

vim.api.nvim_create_augroup('Terminal', { clear = true })
-- start terminal in insert mode
vim.api.nvim_create_autocmd('TermOpen', {
    command = 'setlocal nonumber norelativenumber | startinsert',
    group = 'Terminal'
})
-- close terminal buffer after command finishes
vim.api.nvim_create_autocmd('TermClose', {
    command = 'bw',
    group = 'Terminal'
})

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
-- autopairs
require('nvim-autopairs').setup {
    check_ts = true,
}

-- undotree
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SetFocusWhenToggle = true

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
    kind = 'split',
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
    { 'n', '<leader>gm', function() require('gitsigns').blame_line { full = true } end },
    { 'n', '<leader>gs', require('neogit').open },
}

m.keys_for_filetype {
    { 'DiffviewFiles', 'n', 'q', '<cmd>DiffviewClose<cr>' },
    { 'DiffviewFileHistory', 'n', 'q', '<cmd>DiffviewClose<cr>' },
}
m.key('n', 'U', [[<cmd>UndotreeToggle<cr>]])
