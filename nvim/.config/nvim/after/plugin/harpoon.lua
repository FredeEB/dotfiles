local m = require('functions.keymap')

-- harpoon
require('harpoon').setup {
    global_settings = {
        enter_on_sendcmd = true,
        tmux_autoclose_windows = true,
    }
}

local function run_command(clear)
    clear = clear or false
    local hp = require('harpoon.tmux')
    if clear == true then
        hp.sendCommand('+', 'clear')
    end
    hp.sendCommand('+', 1)
end

m.keys {
    { 'n', '<M-a>', require('harpoon.mark').add_file },
    { 'n', '<M-s>', require('harpoon.ui').toggle_quick_menu },
    { 'n', '<M-j>', function() require('harpoon.ui').nav_file(1) end },
    { 'n', '<M-k>', function() require('harpoon.ui').nav_file(2) end },
    { 'n', '<M-l>', function() require('harpoon.ui').nav_file(3) end },
    { 'n', '<M-;>', function() require('harpoon.ui').nav_file(4) end },
    { 'n', '<M-c>', require('harpoon.cmd-ui').toggle_quick_menu },
    -- send to adjacent pane
    { 'n', '<M-b>', run_command },
    { 'n', '<M-S-b>', function() run_command(true) end },
}

