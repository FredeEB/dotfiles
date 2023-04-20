local m = require('functions.keymap')
-- telescope
local ts = require('telescope')

ts.load_extension('advanced_git_search')
ts.load_extension('git_worktree')
ts.load_extension('undo')
ts.load_extension('persisted')

-- paths patterns to ignore in pickers
local ignore_paths = { '.git', '.clangd', 'node_modules', 'target', 'dist' }

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
                    ["<cr>"] = require("telescope-undo.actions").restore,
                },
                n = {
                    ["y"] = require("telescope-undo.actions").yank_additions,
                    ["Y"] = require("telescope-undo.actions").yank_deletions,
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
            '--smart-case',
            '--hidden',
        },
    }
}
local function open_config()
    require('telescope.builtin').find_files {
        cwd = vim.fn.stdpath('config')
    }
end 
local function search_config()
    require('telescope.builtin').live_grep {
        cwd = vim.fn.stdpath('config')
    }
end 

m.keys { -- telescope
    { 'n', '<leader>ff', require('telescope.builtin').find_files },
    { 'n', '<leader>fg', require('telescope.builtin').live_grep },
    { 'n', '<leader>fr', require('telescope.builtin').grep_string },
    { 'n', '<leader>fe', open_config },
    { 'n', '<leader>fw', search_config },
    { 'n', '<leader>b', require('telescope.builtin').buffers },
    { 'n', '<leader>gb', require('telescope.builtin').git_branches },
    { 'n', '<leader>h', require('telescope.builtin').help_tags },
}

m.keys { -- extensions
    { 'n', '<leader>gw', require('telescope').extensions.git_worktree.git_worktrees },
    { 'n', '<leader>gtc', require('telescope').extensions.git_worktree.create_git_worktree },
    { 'n', '<leader>ghb', require('telescope').extensions.advanced_git_search.diff_branch_file },
    { 'n', '<leader>ghl', require('telescope').extensions.advanced_git_search.diff_commit_line },
    { 'n', '<leader>ghf', require('telescope').extensions.advanced_git_search.diff_commit_file },
    { 'n', '<leader>ghs', require('telescope').extensions.advanced_git_search.search_log_content },
    { 'n', '<leader>ghr', require('telescope').extensions.advanced_git_search.checkout_reflog },
    { 'n', 'U', require('telescope').extensions.undo.undo },
}
