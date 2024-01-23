-- lualine setup
local function relative_file_name()
    return vim.fn.expand('%')
end

require('lualine').setup({
    options = {
        theme = 'auto',
        icons_enabled = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {},
        lualine_c = { relative_file_name },
        lualine_x = { 'filetype' },
        lualine_y = { 'branch' },
        lualine_z = { 'location' },
    },
    interactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { 'filename' },
        lualine_y = { 'branch' },
        lualine_z = { 'location' },
    },
    tabline = {},
    extensions = {}
})

vim.cmd('colorscheme tokyonight')
vim.api.nvim_set_hl(0, 'CursorWord', { bg = "#383A46", bold = true })

