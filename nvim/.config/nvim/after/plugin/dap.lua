local m = require('functions.keymap')
-- dap
local dap = require('dap')

local function query_executable()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local function query_target()
    return vim.fn.input('Target <IP:PORT>: ')
end

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
        args = { '--debugger', '--debugger-pipe', '${pipe}' }
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
    command = 'OpenDebugAD7',
}
dap.configurations.cpp = {
    {
        name = 'Debug program',
        type = 'codelldb',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerPath = 'gdb',
        cwd = '${workspaceFolder}',
        program = query_executable
    }, {
        name = 'Attach to gdbserver',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = query_target,
        miDebuggerPath = 'gdb',
        cwd = '${workspaceFolder}',
        program = query_executable
    },
}
dap.configurations.c = dap.configurations.cpp

require('mason-nvim-dap').setup {
    ensure_installed = { "cppdbg" },
    automatic_setup = true,
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
