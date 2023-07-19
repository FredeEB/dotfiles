require('alias-nvim').setup {
    gl = 'FzfLua git_commits cwd=$PWD',
    gs = 'Neogit',
    gd = 'DiffviewOpen',
    gw = 'FzfLua git_worktree',
    gbr = 'FzfLua git_branches',
    v = 'e $1',
    m = 'Man $1',
}
