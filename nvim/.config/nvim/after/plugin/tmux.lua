local m = require('functions.keymap')
local term = require('terminal')

vim.api.nvim_create_augroup('TmuxManip', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function ()
        local nvim_sock = os.getenv('NVIM')
        if os.getenv('TMUX') and nvim_sock ~= nil and not os.rename(nvim_sock, nvim_sock) then
            vim.fn.system([[tmux setenv NVIM ]] .. vim.v.servername)
        end
    end
})
vim.api.nvim_create_autocmd('VimLeave', {
    callback = function ()
        if os.getenv('NVIM') == vim.v.servername then
            vim.fn.system([[tmux setenv -u NVIM]])
        end
    end
})

m.keys {
    -- Open new terminals
    { 'n', '<leader><leader>', function() term.open_terminal { replace = true } end },
    { 'n', '<leader>j',        function() term.open_terminal { vertical = true } end },
    { 'n', '<leader>k',        term.open_terminal },
}
