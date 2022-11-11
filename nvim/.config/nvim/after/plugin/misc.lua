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

-- tmux
require('tmux').setup {
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
    command = 'startinsert',
    group = 'Config'
})
-- close terminal buffer after command finishes
vim.api.nvim_create_autocmd('TermClose', {
    command = 'bdelete',
    group = 'Config'
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
m.key('n', 'U', [[<cmd>UndotreeToggle<cr>]])
