local m = require('functions.keymap')
-- telescope
local ts = require('telescope')

ts.load_extension('advanced_git_search')
ts.load_extension('git_worktree')
ts.load_extension('undo')
ts.load_extension('persisted')

ts.setup {
    file_ignore_patterns = { 'node_modules' },
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
            hidden = false,
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

local tsb = require('telescope.builtin')
m.keys { -- telescope
    { 'n', '<leader>gl', tsb.git_commits },
    { 'n', '<leader>gf', tsb.git_bcommits },
    { 'n', '<leader>ff', tsb.find_files },
    { 'n', '<leader>fg', tsb.live_grep },
    { 'n', '<leader>fr', tsb.grep_string },
    { 'n', '<leader>fe', open_config },
    { 'n', '<leader>fw', search_config },
    { 'n', '<leader>p', tsb.registers },
    { 'n', '<leader>b', tsb.buffers },
    { 'n', '<leader>gb', tsb.git_branches },
    { 'n', '<leader>h', tsb.help_tags },
}

m.keys { -- extensions
    { 'n', '<leader>gw', ts.extensions.git_worktree.git_worktrees },
    { 'n', '<leader>gtc', ts.extensions.git_worktree.create_git_worktree },
    { 'n', '<leader>ghb', ts.extensions.advanced_git_search.diff_branch_file },
    { 'n', '<leader>ghl', ts.extensions.advanced_git_search.diff_commit_line },
    { 'n', '<leader>ghf', ts.extensions.advanced_git_search.diff_commit_file },
    { 'n', '<leader>ghs', ts.extensions.advanced_git_search.search_log_content },
    { 'n', '<leader>ghr', ts.extensions.advanced_git_search.checkout_reflog },
    { 'n', 'U', ts.extensions.undo.undo },
}
