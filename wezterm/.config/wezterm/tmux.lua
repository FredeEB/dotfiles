local M = {}

function M.tmux_running()
    local handle = io.popen('tmux list-sessions')
    if handle == nil then
        print('failed running tmux')
        return false
    end
    return handle:read('l') ~= nil
end

function M.tmux_command()
    local arg = ''
    if M.tmux_running() then
        arg = 'a'
    end
    return {'tmux', arg}
end

return M
