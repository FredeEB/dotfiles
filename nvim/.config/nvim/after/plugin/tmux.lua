local m = require('functions.keymap')
local term = require('terminal')

local function set_nvim_env_var()
    local nvim_sock = os.getenv('NVIM')
    if nvim_sock ~= nil and os.rename(nvim_sock, nvim_sock) then return end
    if os.getenv('TMUX') then
        vim.fn.system([[tmux setenv NVIM ]] .. vim.v.servername)
    end
end

local function unset_nvim_env_var()
    if os.getenv('NVIM') == vim.v.servername then
        vim.fn.system([[tmux setenv -u NVIM]])
    end
end

vim.api.nvim_create_augroup('TmuxManip', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', { callback = set_nvim_env_var })
vim.api.nvim_create_autocmd('VimLeave', { callback = unset_nvim_env_var})

m.keys {
    -- Open new terminals
    { 'n', '<leader>j',        function() term.open_terminal { vertical = true } end },
    { 'n', '<leader>k',        term.open_terminal },
}
