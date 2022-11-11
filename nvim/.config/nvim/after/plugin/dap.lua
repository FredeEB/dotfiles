local hydra = require('hydra')
-- dap
local dap = require('dap')
dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopOneEntry = false,
        args = function()
            local args = vim.fn.input('Args: ')
            return vim.fn.split(args, ' ')
        end,
    }
}

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

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
        { 'c', require('dap').continues, { desc = 'continue' } },
        { 'b', require('dap').toggle_breakpoint, { desc = 'toggle breakpoint' } },
        { 's', require('dap').step_over, { desc = 'step over' } },
        { 'i', require('dap').step_into, { desc = 'step into' } },
        { 'q', require('dap').close, { desc = 'stop' } },
    }
})

