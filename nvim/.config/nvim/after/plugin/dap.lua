local m = require('functions.keymap')
-- dap
local dap = require('dap')

dap.adapters.cmake = {
  type = "pipe",
  pipe = "${pipe}",
  executable = {
    command = "cmake",
    args = {"--debugger", "--debugger-pipe", "${pipe}"}
  }
}
dap.configurations.cmake = {
  {
    name = "Build",
    type = "cmake",
    request = "launch",
  }
}

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = 'OpenDebugAD7',
}
dap.configurations.cpp = {
    {
        name = 'Debug program',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerPath = 'gdb',
        cwd = '${workspaceFolder}',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
    },
    {
        name = 'Attach to gdbserver',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:5555',
        miDebuggerPath = 'gdb',
        cwd = '${workspaceFolder}',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
    },
}

require('mason-nvim-dap').setup {
    ensure_installed = { "cppdbg" },
    automatic_setup = true,
}

local widgets = require('dap.ui.widgets')
m.keys {
    { 'n', '<leader>dd', dap.continue },
    { 'n', '<leader>db', dap.toggle_breakpoint },
    { 'n', '<leader>du', function () widgets.centered_float(widgets.scopes).open() end },
    { 'n', '<leader>ds', widgets.hover },
    { 'n', '<leader>dn', function() dap.step_over() end },
    { 'n', '<leader>di', dap.step_into },
    { 'n', '<leader>do', dap.step_out },
    { 'n', '<leader>dx', dap.terminate },
    { 'n', '<leader>dr', dap.repl.open },
}
