-- telescope extensions
local ts = require('telescope')
ts.setup({
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
})
ts.load_extension('git_worktree')
ts.load_extension('notify')
ts.load_extension('project')
ts.load_extension('fzf')

local m = require('functions.keymap')

m.keys{ -- regular keybinds
    {'n', '<leader>fd', [[<cmd>Telescope file_browser<cr>]]},
    {'n', '<leader>ff', [[<cmd>Telescope find_files<cr>]]},
    {'n', '<leader>fg', [[<cmd>Telescope live_grep<cr>]]},
    {'n', '<leader>fr', [[<cmd>Telescope grep_string<cr>]]},
    {'n', '<leader>fe', [[<cmd>lua require('telescope.builtin').find_files({cwd = vim.fn.stdpath('config')})<cr>]]},
    {'n', '<leader>b', [[<cmd>Telescope buffers<cr>]]},
    {'n', '<leader>gb', [[<cmd>Telescope git_branches<cr>]]},
    {'n', '<leader>h', [[<cmd>Telescope help_tags<cr>]]}
}

m.keys{ -- extensions
    {'n', '<leader>j', [[<cmd>lua require('telescope').extensions.project.project{}<cr>]]},
    {'n', '<leader>gw', [[<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>]]},
    {'n', '<leader>gtc', [[<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>]]},
}
