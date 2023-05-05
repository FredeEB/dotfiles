local default_terminal_options = {
    replace = false,
    vertical = false,
    shell = 'screen',
    shell_params = {},
    session = nil,
}

local function join(list, ch)
    ch = ch or ' '
    local res = ''
    for _, item in pairs(list) do
        res = res .. item .. ch
    end
    return res
end

local function get_opts(opts)
    if opts == nil then
        return default_terminal_options
    end
    local res = {}
    for k, v in pairs(default_terminal_options) do
        res[k] = v
    end
    for k, v in pairs(opts) do
        res[k] = v
    end
    return res
end

local get_shell_command = function(opts)
    local vim_cmd = 'split'
    if opts.replace then
        vim_cmd 'e'
    elseif opts.vertical then
        vim_cmd = 'vsplit'
    end
    return vim_cmd .. ' term://' .. opts.shell .. ' ' .. join(opts.shell_params)
end

local attach_to_screen_session = function(session, opts)
    local cmd =
        vim.cmd(get_shell_command(opts) .. session)
end

local get_screen_sessions = function()
    local res = {}
    for session in vim.fs.dir('/run/screens/S-' .. os.getenv('USER')) do
        local program = 'bash'
        table.insert(res, {
            session = session,
            program = program,
        })
    end
    return res
end

local open_terminal = function(opts)
    opts = get_opts(opts)
    if opts.session == nil then
        local c = get_shell_command(opts)
        vim.cmd(c)
    else
        attach_to_screen_session(sessions[1], opts)
    end
end

return {
    open_terminal = open_terminal,
    get_screen_sessions = get_screen_sessions,
}
