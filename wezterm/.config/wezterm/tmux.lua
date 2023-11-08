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
    local command = {'tmux'}
    if M.tmux_running() then
        table.insert(command, 'a')
    end
    return command
end

return M
