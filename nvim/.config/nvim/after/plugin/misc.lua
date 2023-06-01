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
vim.g.netrw_keepdir = 0 
vim.o.jumpoptions = 'stack'

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
    { 'v', '<', [[<gv]] },
    { 'v', '>', [[>gv]] },
}

m.keys { -- window actions
    { 'n', '<C-h>', '<C-w>h' },
    { 'n', '<C-j>', '<C-w>j' },
    { 'n', '<C-k>', '<C-w>k' },
    { 'n', '<C-l>', '<C-w>l' },
}

m.keys_for_filetype ({
    { 'netrw', 'n', '<C-h>', '<C-w>h' },
    { 'netrw', 'n', '<C-j>', '<C-w>j' },
    { 'netrw', 'n', '<C-k>', '<C-w>k' },
    { 'netrw', 'n', '<C-l>', '<C-w>l' }},
    { noremap = false, buffer = 0, })

m.keys {
    {'v', 'p', '"_dP'}
}

m.keys { -- closing files
    { 'n', '<leader>q', [[<cmd>bd<cr>]] },
    { 'n', '<leader>Q', [[<cmd>q!<cr>]] },
}

m.keys { -- qfl
    { 'n', '<C-p>', [[<cmd>cprev<cr>zz]] },
    { 'n', '<C-n>', [[<cmd>cnext<cr>zz]] },
    { 'n', '<C-q>', [[<cmd>copen<cr>]] },
    { 'n', '<C-c>', [[<cmd>lclose | cclose<cr>]] },
    { 'n', '<M-p>', [[<cmd>lprev<cr>zz]] },
    { 'n', '<M-n>', [[<cmd>lnext<cr>zz]] },
    { 'n', '<M-q>', [[<cmd>lopen<cr>]] },
    { 'n', '<leader>l', [[<cmd>lvim // % | lopen<cr>]] }
}

m.keys { -- misc
    { 'n', 'gf', 'gF' },
}

for _, cmd in ipairs { '<C-d>', '<C-u>', '<C-i>', '<C-o>', 'n', 'N', '*', '%' } do
    m.key('n', cmd, cmd .. 'zz', { noremap = true })
end

-- close vim if only the qfl is open
vim.api.nvim_create_autocmd('WinEnter', {
    command = [[if winnr('$') == 1 && &buftype == 'quickfix' | q | endif]]
})

vim.notify = require('notify')

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

require('Comment').setup()
local ft = require('Comment.ft')
ft.cpp = {'// %s', '// %s'}
ft.c = {'// %s', '// %s'}
