local default_terminal_options = {
    replace = false,
    vertical = false,
    keep_dir = true,
}

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

local open_terminal = function(opts)
    opts = get_opts(opts)
    local args = opts.keep_dir and ' -c %:p:h' or ''
    vim.cmd('silent !export NVIM=$NVIM')
    if opts.replace then
        vim.cmd('silent !tmux neww' .. args)
    else
        local direction = opts.vertical and ' -h' or ' -v'
        vim.cmd('silent !tmux split' .. direction .. args)
    end
end

return {
    open_terminal = open_terminal,
}
