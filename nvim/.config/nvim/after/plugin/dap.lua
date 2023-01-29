local hydra = require('hydra')
-- dap
local dap = require('dap')

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = 'OpenDebugAD7',
}
dap.configurations.cpp = {
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
    }
}

require('mason-nvim-dap').setup {
    ensure_installed = { "cppdbg" },
    automatic_setup = true,
}

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

hydra({
    name = 'Dap Debug',
    config = {
        foreign_keys = 'run',
        exit = false,
        invoke_on_body = true,
    },
    mode = { 'n', 'x' },
    body = '<leader>d',
    heads = {
        { 'c', require('dap').continue, { desc = 'continue' } },
        { 'b', require('dap').toggle_breakpoint, { desc = 'toggle breakpoint' } },
        { 's', require('dap').step_over, { desc = 'step over' } },
        { 'i', require('dap').step_into, { desc = 'step into' } },
        { 'q', require('dap').close, { desc = 'stop' } },
    }
})
