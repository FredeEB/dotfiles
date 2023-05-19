require('alias-nvim').setup {
    gl = 'Telescope git_commits cwd=$PWD',
    gs = 'Neogit',
    gd = 'DiffviewOpen',
    gw = 'Telescope git_worktree',
    v = 'e $1',
    man = 'e man://$1',
}
