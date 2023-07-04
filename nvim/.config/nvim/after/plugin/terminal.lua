local m = require('functions.keymap')
local term = require('terminal')

vim.o.scrollback = 100000

m.keys {
    { 't', '<C-h>', '<C-\\><C-N><C-w>h' },
    { 't', '<C-j>', '<C-\\><C-N><C-w>j' },
    { 't', '<C-k>', '<C-\\><C-N><C-w>k' },
    { 't', '<C-l>', '<C-\\><C-N><C-w>l' },
    { 't', '<esc>', '<C-\\><C-n>' },
}
m.keys {
    -- Open new terminals
    { 'n', '<leader><leader>', function() term.open_terminal { replace = true } end },
    { 'n', '<leader>j',        function() term.open_terminal { vertical = true } end },
    { 'n', '<leader>k',        term.open_terminal },
}

vim.api.nvim_create_augroup('Terminal', { clear = true })
-- close terminal buffer after command finishes
vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()

        local id = vim.api.nvim_create_augroup('TerminalLocal', { clear = true })
        vim.api.nvim_create_autocmd('TermClose', {
            command = 'bd',
            group = 'TerminalLocal'
        })
        m.key('n', '<leader>q', function()
            vim.api.nvim_clear_autocmds { group = id }
            vim.cmd('bd!')
        end)

        vim.cmd('setl nonumber norelativenumber')
        vim.cmd('startinsert')
    end,
    group = 'Terminal'
})

require('term-edit').setup {
    prompt_end = "❯ ",
}
