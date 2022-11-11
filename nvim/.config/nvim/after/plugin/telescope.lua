local m = require('functions.keymap')
-- telescope
local ignore_paths = { '.git', '.clangd', 'node_modules', 'target', 'dist'}
local ts = require('telescope')
ts.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = 'smart_case',
        }
    },
    pickers = {
        find_files = {
            hidden = true,
            file_ignore_patterns = ignore_paths
        },
        live_grep = {
            file_ignore_patterns = ignore_paths
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
-- telescope extensions
ts.load_extension('git_worktree')
ts.load_extension('fzf')

m.keys { -- telescope
    { 'n', '<leader>ff', require('telescope.builtin').find_files },
    { 'n', '<leader>fg', require('telescope.builtin').live_grep },
    { 'n', '<leader>fr', require('telescope.builtin').grep_string },
    { 'n', '<leader>b', require('telescope.builtin').buffers },
    { 'n', '<leader>gb', require('telescope.builtin').git_branches },
    { 'n', '<leader>h', require('telescope.builtin').help_tags }
}

m.keys { -- extensions
    { 'n', '<leader>gw', require('telescope').extensions.git_worktree.git_worktrees },
    { 'n', '<leader>gtc', require('telescope').extensions.git_worktree.create_git_worktree },
}


