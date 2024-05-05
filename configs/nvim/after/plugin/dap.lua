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
    cppdbg = { "c", "cpp" },
    codelldb = { "c", "cpp" },
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
        program = "${file}",
        cwd = "${fileDirname}",
    }
}

dap.adapters.cmake = {
    type = 'pipe',
    pipe = '${pipe}',
    executable = {
        command = 'cmake',
        args = { '--debugger', '--debugger-pipe', '${pipe}', 'build'}
    }
}
dap.configurations.cmake = {
    {
        name = 'Build',
        type = 'cmake',
        request = 'launch',
    }
}

dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        command = 'codelldb',
        args = {'--port', "${port}"},
    },
}
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    executable = {
        command = 'gdb',
        args = {'-i', 'dap'},
    },
}

dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
    }
}

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

local widgets = require('dap.ui.widgets')
m.keys {
    { 'n', '<leader>dd', dap.continue },
    { 'n', '<leader>dl', dap.run_last },
    { 'n', '<leader>db', dap.toggle_breakpoint },
    { 'n', '<leader>du', function () widgets.centered_float(widgets.scopes).open() end },
    { 'n', '<leader>ds', widgets.hover },
    { 'n', '<leader>dn', dap.step_over },
    { 'n', '<leader>di', dap.step_into },
    { 'n', '<leader>do', dap.step_out },
    { 'n', '<leader>dx', dap.terminate },
    { 'n', '<leader>dr', dap.repl.open },
}

m.keys_for_filetype {
    {'dap-float', 'n', 'q', '<cmd>q<cr>'}
}
