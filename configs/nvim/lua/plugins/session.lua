local m = require('functions.keymap')

require('persisted').setup({
    dir = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/'),
    use_git_branch = true,
})
vim.o.sessionoptions = 'buffers,curdir,tabpages,winsize'

m.keys({
    { 'n', '<leader>as', require('persisted').load },
    { 'n', '<leader>ad', require('persisted').stop },
})
