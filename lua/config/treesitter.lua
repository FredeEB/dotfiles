local m = require('functions.keymap')

require('nvim-treesitter.configs').setup({
    -- Don't do the following without internet
    ensure_installed = 'maintained',
    -- enable all the treesitter features
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = true },
    matchup = { enable = true },
})

m.keys {
    {'x', 'iu', [[:lua require('treesitter-unit').select()<cr>]]},
    {'x', 'au', [[:lua require('treesitter-unit').select(true)<cr>]]},
    {'o', 'iu', [[:<c-u>lua require('treesitter-unit').select()<cr>]]},
    {'o', 'au', [[:<c-u>lua require('treesitter-unit').select(true)<cr>]]},
}
