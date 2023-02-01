local m = require('functions.keymap')

require('neogit').setup {
    use_magit_keybinds = true,
    kind = 'split',
    auto_show_console = false,
    disable_builtin_notifications = true,
    disable_commit_confirmation = true,
    integrations = {
        diffview = true,
    }
}

local vgit = require('vgit')
vgit.setup()

local diffview = require('diffview')
diffview.setup()

m.keys {
    { 'n', '<leader>gq', vgit.project_hunks_preview },
    { 'n', '<leader>ga', vgit.buffer_hunk_stage },
    { 'n', '<leader>gA', vgit.buffer_stage },
    { 'n', '<leader>gu', vgit.buffer_unstage },
    { 'n', '<leader>gr', vgit.buffer_hunk_reset },
    { 'n', '<leader>gR', vgit.buffer_reset },
    { { 'n', 'v' }, '<leader>ga', vgit.buffer_hunk_stage },
    { { 'n', 'v' }, '<leader>gr', vgit.buffer_hunk_reset },
    { 'n', '<leader>gp', vgit.buffer_hunk_preview },
    { 'n', '<leader>gm', vgit.buffer_blame_preview },
    { 'n', '<leader>gM', vgit.buffer_gutter_blame_preview },
    { 'n', '<leader>gs', require('neogit').open },
}
