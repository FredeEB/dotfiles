local m = require('functions.keymap')

require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 500,
    }
})

m.keys_for_filetype{
    {'fugitive', 'n', 'q', 'gq'},
    {'fugitiveblame', 'n', 'q', 'gq'},

    {'git', 'n', 'q', '<cmd>q<cr>'}
}

m.keys{
    {'n', '<leader>gs', [[<cmd>G<cr>]]},
    {'n', '<leader>gb', [[<cmd>G blame<cr>]]},
    {'n', '<leader>gll', [[<cmd>Gclog<cr>]]},
    {'n', '<leader>glf', [[<cmd>Gclog %<cr>]]},
    {'n', '<leader>gm', [[<cmd>GitMessenger<cr>]]},
}
