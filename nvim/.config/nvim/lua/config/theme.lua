local lualine_or_tmux_git = function()
    if (os.getenv("TMUX") == nil) then
        local file = io.popen('git branch --show', 'r')
        local res = file:read()
        file:close()
        return res
    else
        return ''
    end
end

-- lualine setup
require('lualine').setup({
    options = { 
        theme = 'dracula-nvim',
        icons_enabled = true,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {lualine_or_tmux_git},
        lualine_c = {'filename'},
        lualine_x = {'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    interactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
})

vim.g.dracula_transparent_bg = true
vim.g.dracula_lualine_bg_color = "#44475a"
vim.g.dracula_show_end_of_buffer = true
vim.cmd('colorscheme dracula')

