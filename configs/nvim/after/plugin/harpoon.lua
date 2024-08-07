local m = require('functions.keymap')
local harpoon = require("harpoon")

harpoon:setup()

m.keys({ 
    { 'n', '<M-m>', function() harpoon:list():add() end, },
    { 'n', '<M-u>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, },
    { 'n', '<M-j>', function() harpoon:list():select(1) end, },
    { 'n', '<M-k>', function() harpoon:list():select(2) end, },
    { 'n', '<M-l>', function() harpoon:list():select(3) end, },
    { 'n', '<M-;>', function() harpoon:list():select(4) end, },
})
