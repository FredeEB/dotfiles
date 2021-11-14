local map = {}
-- these are some global functions for creating keybinds that make my config look neat
-- keybind convenience function
map.key = function(mode, mapping, cmd, options)
    options = options or { noremap = true }
    vim.api.nvim_set_keymap(mode, mapping, cmd, options)
end
-- map many keys at once
map.keys = function(maps, options)
    options = options or { noremap = true }
    for v = 1, #maps do
        map.key(maps[v][1], maps[v][2], maps[v][3], options)
    end
end

-- map keys for filetypes
map.key_for_filetype = function(filetype, mode, mapping, cmd)
    vim.cmd("autocmd FileType " .. filetype .. " " .. mode .. "map <buffer> " .. mapping .. " " .. cmd)
end
-- map many keys at once for filetype
map.keys_for_filetype = function(maps)
    for v = 1, #maps do
        map.key_for_filetype(maps[v][1], maps[v][2], maps[v][3], maps[v][4])
    end
end

return map
