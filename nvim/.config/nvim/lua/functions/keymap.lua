local map = {}
-- these are some global functions for creating keybinds that make my config look neat
-- keybind convenience function
function map.key(mode, mapping, cmd, options)
    options = options or { noremap = true, buffer = 0 }
    vim.keymap.set(mode, mapping, cmd, options)
end
-- map many keys at once
function map.keys(maps, options)
    options = options or { noremap = true }
    for v = 1, #maps do
        map.key(maps[v][1], maps[v][2], maps[v][3], options)
    end
end

-- map keys for filetypes
vim.api.nvim_create_augroup('KeybindsForMode', { clear = true })
function map.key_for_filetype(filetype, mode, mapping, cmd)
    vim.api.nvim_create_autocmd('FileType', {
        group = 'KeybindsForMode',
        pattern = filetype,
        callback = function()
            map.key(mode, mapping, cmd)
        end
    })
end
-- map many keys at once for filetype
function map.keys_for_filetype(maps)
    for v = 1, #maps do
        map.key_for_filetype(maps[v][1], maps[v][2], maps[v][3], maps[v][4])
    end
end

return map
