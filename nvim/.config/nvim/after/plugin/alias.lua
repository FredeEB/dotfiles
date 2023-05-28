require('alias-nvim').setup {
    gl = 'Telescope git_commits cwd=$PWD',
    gs = 'Neogit',
    gd = 'DiffviewOpen',
    gw = 'Telescope git_worktree',
    gbr = 'Telescope git_branches',
    v = 'e $1',
    m = 'e man://$1',
}
