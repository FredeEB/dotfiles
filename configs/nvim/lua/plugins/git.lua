local m = require('functions.keymap')

require('neogit').setup({
    use_magit_keybinds = true,
    kind = 'split',
    auto_show_console = false,
    disable_builtin_notifications = true,
    disable_commit_confirmation = true,
    integrations = {
        diffview = true,
    },
})

require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 500,
    },
})

m.keys({
    { 'n', '<leader>gq', require('gitsigns').setqflist },
    { 'n', '<leader>gA', require('gitsigns').stage_buffer },
    { 'n', '<leader>gR', require('gitsigns').reset_buffer },
    { { 'n', 'v' }, '<leader>ga', require('gitsigns').stage_hunk },
    { { 'n', 'v' }, '<leader>gr', require('gitsigns').reset_hunk },
    { 'n', '<leader>gu', require('gitsigns').undo_stage_hunk },
    { 'n', '<leader>gp', require('gitsigns').preview_hunk },
    {
        'n',
        '<leader>gm',
        function()
            require('gitsigns').blame_line({ full = true })
        end,
    },
    { 'n', '<leader>gs', require('neogit').open },
})

m.keys_for_filetype({
    { 'DiffViewFile', 'n', 'q', '<cmd>DiffviewClose<cr>' },
})
