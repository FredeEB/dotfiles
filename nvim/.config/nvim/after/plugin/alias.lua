require('alias-nvim').setup {
    commands = {
        v = 'cd $PWD | e ${1:-.}',
        m = 'Man $1',
    },
    functions = {
        gs = function (cwd) require('neogit').open { cwd = cwd } end,
        gd = function (cwd) require('diffview').open { cwd = cwd } end,
        gl = function () require('fzf-lua').git_commits() end,
        gb = function () require('fzf-lua').git_branches() end,
    }
}
