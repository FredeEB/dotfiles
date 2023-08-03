local m = require('functions.keymap')
local term = require('terminal')

if os.getenv('TMUX') then
    vim.cmd('silent !tmux setenv -g NVIM ' .. vim.v.servername)
end

m.keys {
    -- Open new terminals
    { 'n', '<leader><leader>', function() term.open_terminal { replace = true } end },
    { 'n', '<leader>j',        function() term.open_terminal { vertical = true } end },
    { 'n', '<leader>k',        term.open_terminal },
}
