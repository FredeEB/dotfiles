local m = require('functions.keymap')

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    matchup = { enable = true },
})

-- tree-climber/hopper
m.key('o', 'm', require('tsht').nodes, { remap = false })
m.key('x', 'm', require('tsht').nodes, { remap = true })

-- treesj
m.key('n', '<leader>,', require('treesj').toggle)

