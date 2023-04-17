local m = require('functions.keymap')

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
    command = 'bd',
    group = 'Terminal'
})

require('term-edit').setup {
    prompt_end = "❯ ",
}

