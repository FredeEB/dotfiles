
-- general settings
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.expandtab = true
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.rnu = true
vim.o.nu = true
vim.o.scrolloff = 15
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.wildmode = 'longest,list'
vim.o.inccommand = 'nosplit'
vim.o.termguicolors = true

local m = require('functions.keymap')

m.key('n', '<Space>', '', {})
vim.g.mapleader = ' '

m.keys{ -- undo tags
    {'i', ',', [[<C-g>u,]]},
    {'i', '.', [[<C-g>u.]]},
    {'i', '!', [[<C-g>u!]]},
    {'i', '?', [[<C-g>u?]]},
    {'i', ';', [[<C-g>u;]]},
}

m.keys{ -- vblock moves
    {'v', 'K', [[:m '<-2<cr>gv=gv]]},
    {'v', 'J', [[:m '>+1<cr>gv=gv]]},
}

m.keys{ -- closing files
    {'n', '<leader>q', [[<cmd>bdelete<cr>]]},
    {'n', '<leader>Q', [[<cmd>q!<cr>]]},
}

m.keys{ -- clipboard
    {'v', '<leader>y', '"+y'},
    {'n', '<leader>y', '"+y'},
    {'n', '<leader>Y', '"+Y'},
    {'n', '<leader>p', '"+p'},
    {'n', '<leader>P', '"+P'},
}

m.keys{ -- tmux
    {'n', '<leader>t', [[<cmd>!tmux split-window -h -c %:p:h<cr><cmd>redraw!<cr>]]},
    {'n', '<leader>gr', [[<cmd>!tmux split-window -h -c `git rev-parse --show-toplevel`<cr><cmd>redraw!<cr>]]}
}

m.keys{ -- qfl
    {'n', '<C-p>', [[<cmd>cprev<cr>]]},
    {'n', '<C-n>', [[<cmd>cnext<cr>]]},
    {'n', '<C-q>', [[<cmd>copen<cr>]]},
    {'n', '<C-c>', [[<cmd>cclose<cr>]]},
    {'n', '*', [[:execute 'vimgrep '.expand('<cword>').' '.expand('%') | :copen | :cc<cr>]]}
}

m.keys{ -- misc
    {'n', 'n', [[nzzzv]]},
    {'n', 'N', [[Nzzzv]]},
    {'n', 'J', [[mzJ`z]]},
}
require('plugins')

require('config.lsps')
require('config.git')
require('config.telescope')
require('config.treesitter')
require('config.misc')
require('config.theme')

