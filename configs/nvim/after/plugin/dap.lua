local m = require('functions.keymap')
-- dap
local dap = require('dap')

local function query_executable()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local function query_target()
    return vim.fn.input('Target <IP:PORT>: ')
end

require('dap.ext.vscode').type_to_filetypes = {
    gdb = { 'c', 'cpp' },
    cppdbg = { 'c', 'cpp' },
    codelldb = { 'c', 'cpp' },
}

dap.adapters.bash = {
    type = 'executable',
    command = 'bash-debug-adapter',
}

dap.configurations.sh = {
    {
        name = 'Run',
        type = 'bash',
        request = 'launch',
        program = '${file}',
        cwd = '${fileDirname}',
    },
}

dap.adapters.cmake = {
    type = 'pipe',
    pipe = '${pipe}',
    executable = {
        command = 'cmake',
        args = { '--debugger', '--debugger-pipe', '${pipe}', 'build' },
    },
}
dap.configurations.cmake = {
    {
        name = 'Build',
        type = 'cmake',
        request = 'launch',
    },
}

dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'codelldb',
        args = { '--port', '${port}' },
    },
}
dap.adapters.gdb = {
    id = 'gdb',
    type = 'executable',
    command = 'gdb',
    args = { '-i', 'dap' },
}

dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 })
end

dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
    },
}

local dapui = require('dapui')
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

local Hydra = require('hydra')
local widgets = require('dap.ui.widgets')

local hint = [[
 _n_: step over   _b_: toggle breakpoint
 _s_: step into   _B_: toggle conditional breakpoint
 _o_: step out    _K_: hover

 _c_: continue    _C_: run to cursor

 _q_: end session _Q_: close hydra
]]

local dap_hydra = Hydra({
    hint = hint,
    config = {
        color = 'pink',
        invoke_on_body = true,
        hint = {
            position = 'bottom',
        },
    },
    name = 'dap',
    mode = { 'n', 'x' },
    body = '<leader>d',
    heads = {
        { 'n', dap.step_over, { silent = true } },
        { 's', dap.step_into, { silent = true } },
        { 'o', dap.step_out, { silent = true } },
        { 'c', dap.continue, { silent = true } },
        { 'C', dap.run_to_cursor, { silent = true } },
        { 'q', dap.terminate, { silent = true } },
        { 'b', dap.toggle_breakpoint, { silent = true } },
        {
            'B',
            function()
                vim.ui.input({
                    prompt = 'Condition: ',
                }, function(input)
                    dap.toggle_breakpoint(input)
                end)
            end,
            { silent = true },
        },
        { 'K', widgets.hover, { silent = true } },
        { 'Q', nil, { exit = true, nowait = true } },
    },
})

m.keys_for_filetype({
    { 'dap-float', 'n', 'q', '<cmd>q<cr>' },
})
