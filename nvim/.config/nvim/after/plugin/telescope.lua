local m = require('functions.keymap')
-- telescope
local ignore_paths = { '.git', '.clangd', 'node_modules', 'target', 'dist' }
local ts = require('telescope')
ts.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
        undo = {
            use_delta = false,
            mappings = {
                i = {
                    ["<cr>"] = require("telescope-undo.actions").yank_additions,
                    ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                    ["<C-cr>"] = require("telescope-undo.actions").restore,
                }
            }
        }
    },
    pickers = {
        find_files = {
            hidden = true,
            file_ignore_patterns = ignore_paths
        },
        live_grep = {
            file_ignore_patterns = ignore_paths
        },
        buffers = {
            show_all_buffers = true,
            sort_mru = true,
            mappings = {
                n = {
                    ["d"] = "delete_buffer"
                }
            }
        }
    },
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--ignore',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--trim',
            '--smart-case'
        },
    }
}

m.keys { -- telescope
    { 'n', '<leader>ff', require('telescope.builtin').find_files },
    { 'n', '<leader>fg', require('telescope.builtin').live_grep },
    { 'n', '<leader>fr', require('telescope.builtin').grep_string },
    { 'n', '<leader>b', require('telescope.builtin').buffers },
    { 'n', '<leader>gb', require('telescope.builtin').git_branches },
    { 'n', '<leader>h', require('telescope.builtin').help_tags },
}

m.keys { -- extensions
    { 'n', '<leader>gw', require('telescope').extensions.git_worktree.git_worktrees },
    { 'n', '<leader>gtc', require('telescope').extensions.git_worktree.create_git_worktree },
    { 'n', 'U', require('telescope').extensions.undo.undo },
}
