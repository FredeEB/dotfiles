local m = require('functions.keymap')

-- harpoon
require('harpoon').setup {
    global_settings = {
        enter_on_sendcmd = true,
        tmux_autoclose_windows = true,
    }
}

local function run_command(clear, index)
    clear = clear or false
    local hp = require('harpoon.tmux')
    if clear == true then
        hp.sendCommand('+', 'clear')
    end
    hp.sendCommand('+', index)
end

m.keys {
    { 'n', '<M-m>', require('harpoon.mark').add_file },
    { 'n', '<M-u>', require('harpoon.ui').toggle_quick_menu },
    { 'n', '<M-j>', function() require('harpoon.ui').nav_file(1) end },
    { 'n', '<M-k>', function() require('harpoon.ui').nav_file(2) end },
    { 'n', '<M-l>', function() require('harpoon.ui').nav_file(3) end },
    { 'n', '<M-;>', function() require('harpoon.ui').nav_file(4) end },

    { 'n', '<M-c>', require('harpoon.cmd-ui').toggle_quick_menu },
    { 'n', '<M-a>', function() run_command(false, 1) end },
    { 'n', '<M-s>', function() run_command(false, 2) end },
    { 'n', '<M-d>', function() run_command(false, 3) end },
    { 'n', '<M-f>', function() run_command(false, 4) end },
    { 'n', '<M-S-a>', function() run_command(true, 1) end },
    { 'n', '<M-S-s>', function() run_command(true, 2) end },
    { 'n', '<M-S-d>', function() run_command(true, 3) end },
    { 'n', '<M-S-f>', function() run_command(true, 4) end },
}

