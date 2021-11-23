local m = require('functions.keymap')

require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 500,
    }
})

require('diffview').setup({
    enhanced_diff_hl = true
})

m.keys_for_filetype{
    {'fugitive', 'n', 'q', 'gq'},
    {'fugitive', 'n', 'd', '<cmd>DiffviewOpen<cr>'},
    {'fugitiveblame', 'n', 'q', 'gq'},

    {'DiffviewFiles', 'n', 'q', '<cmd>DiffviewClose<cr>'},
    {'DiffviewFileHistory', 'n', 'q', '<cmd>DiffviewClose<cr>'},
    {'git', 'n', 'q', '<cmd>q<cr>'},

    {'git', 'n', 'q', '<cmd>q<cr>'}
}

m.keys{
    {'n', '<leader>gs', [[<cmd>G<cr>]]},
    {'n', '<leader>gb', [[<cmd>G blame<cr>]]},
    {'n', '<leader>gll', [[<cmd>Gclog<cr>]]},
    {'n', '<leader>glf', [[<cmd>Gclog %<cr>]]},
    {'n', '<leader>gd', [[<cmd>DiffviewOpen<cr>]]},
    {'n', '<leader>gh', [[<cmd>DiffviewFileHistory %<cr>]]},
    {'n', '<leader>gm', [[<cmd>GitMessenger<cr>]]},
}
