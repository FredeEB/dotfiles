local m = require('functions.keymap')
-- dap
local dap = require('dap')

require('dap.ext.vscode').type_to_filetypes = {
    gdb = { 'c', 'cpp' },
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

dap.adapters.gdb = {
    id = 'gdb',
    type = 'executable',
    command = 'gdb',
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
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

local widgets = require('dap.ui.widgets')

m.keys {
    { 'n', '<F2>', dap.step_over },
    { 'n', '<F3>', dap.step_into },
    { 'n', '<F4>', dap.step_out },
    { 'n', '<F5>', dap.continue },
    { 'n', '<F6>', dap.run_to_cursor },
    { 'n', '<leader>K', widgets.hover },
    { 'n', '<F3>', dap.toggle_breakpoint },
    { 'n', 'S-<F5>', function()
        dap.disconnect()
        dap.terminate()
        dap.close()
        dapui.close()
    end }
}

m.keys_for_filetype({
    { 'dap-float', 'n', 'q', '<cmd>q<cr>' },
})
