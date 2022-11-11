local m = require('functions.keymap')
-- git
require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 500,
    }
})

require('neogit').setup {
    use_magit_keybinds = true,
    integrations = {
        diffview = true
    },
    kind = 'split',
    disable_builtin_notifications = true,
    disable_commit_confirmation = true,
}

m.keys {
    { 'n', '<leader>gq', require('gitsigns').setqflist },
    { 'n', '<leader>gA', require('gitsigns').stage_buffer },
    { 'n', '<leader>gR', require('gitsigns').reset_buffer },
    { { 'n', 'v' }, '<leader>ga', require('gitsigns').stage_hunk },
    { { 'n', 'v' }, '<leader>gr', require('gitsigns').reset_hunk },
    { 'n', '<leader>gu', require('gitsigns').undo_stage_hunk },
    { 'n', '<leader>gp', require('gitsigns').preview_hunk },
    { 'n', '<leader>gd', require('diffview').open },
    { 'n', '<leader>gm', function() require('gitsigns').blame_line { full = true } end },
    { 'n', '<leader>gs', require('neogit').open },
}

m.keys_for_filetype {
    { 'DiffviewFiles', 'n', 'q', '<cmd>DiffviewClose<cr>' },
    { 'DiffviewFileHistory', 'n', 'q', '<cmd>DiffviewClose<cr>' },
}
