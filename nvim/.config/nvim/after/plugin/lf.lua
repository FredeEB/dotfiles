local lf = require('lf')
local m = require('functions.keymap')
lf.setup()

m.keys {
    { 'n', '<leader>fd', lf.start }
}
