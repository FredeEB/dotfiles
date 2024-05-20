require('alias-nvim').setup({
    commands = {
        v = 'cd $PWD | e ${1:-.}',
        m = 'Man $1',
    },
    functions = {
        gs = function(opts)
            require('neogit').open({ cwd = opts.cwd })
        end,
        gd = function(opts)
            require('diffview').open({ cwd = opts.cwd })
        end,
        gl = function(opts)
            require('fzf-lua').git_commits({ cwd = opts.cwd })
        end,
        gb = function(opts)
            require('fzf-lua').git_branches({ cwd = opts.cwd })
        end,
    },
})
