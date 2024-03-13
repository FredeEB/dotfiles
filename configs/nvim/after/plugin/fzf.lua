local m = require('functions.keymap')
local fzf = require('fzf-lua')
fzf.setup {
    'default',
    fzf_bin = "fzf-tmux",
    keymap = {
        fzf = {
            ["ctrl-q"] = "select-all+accept",
        }
    },
    winopts = {
        preview = {
            default = 'bat'
        }
    },
    grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
    },
    files = {
        rg_opts = "--color=never --files --follow",
    },
    previewers = {
        bat = {
            theme = 'Dracula'
        }
    }
}

local function open_config()
    fzf.files {
        cwd = vim.fn.stdpath('config')
    }
end
local function search_config()
    fzf.live_grep {
        cwd = vim.fn.stdpath('config')
    }
end

m.keys {
    { 'n', '<leader><leader>', fzf.resume },
    { 'n', '<leader>gl', fzf.git_commits },
    { 'n', '<leader>gf', fzf.git_bcommits },
    { 'n', '<leader>ff', fzf.files },
    { 'n', '<leader>fg', fzf.live_grep },
    { 'n', '<leader>fr', fzf.grep_cword },
    { 'v', '<leader>fr', fzf.grep_visual },
    { 'n', '<leader>fe', open_config },
    { 'n', '<leader>fw', search_config },
    { 'n', '<leader>;', fzf.commands },
    { 'n', '<leader>b', fzf.buffers },
    { 'n', '<leader>l', fzf.lines },
    { 'n', '<leader>gb', fzf.git_branches },
    { 'n', '<leader>h', fzf.help_tags },
}
