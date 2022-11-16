local m = require('functions.keymap')

-- harpoon
require('harpoon').setup {
    global_settings = {
        enter_on_sendcmd = true,
    }
}

m.keys {
    { 'n', '<M-a>', require('harpoon.mark').add_file },
    { 'n', '<M-s>', require('harpoon.ui').toggle_quick_menu },
    { 'n', '<M-j>', function() require('harpoon.ui').nav_file(1) end },
    { 'n', '<M-k>', function() require('harpoon.ui').nav_file(2) end },
    { 'n', '<M-l>', function() require('harpoon.ui').nav_file(3) end },
    { 'n', '<M-;>', function() require('harpoon.ui').nav_file(4) end },
    { 'n', '<M-c>', require('harpoon.cmd-ui').toggle_quick_menu },
}

