-- lualine setup
local function relative_file_name()
    return vim.fn.expand('%')
end

require('lualine').setup({
    options = {
        theme = 'dracula',
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

vim.g.dracula_lualine_bg_color = '#44475a'
vim.g.dracula_show_end_of_buffer = true
vim.cmd('colorscheme dracula')
vim.api.nvim_set_hl(0, 'CursorWord', { bg = "#383A46", bold = true })
vim.g.cursorword_min_width = 1
vim.g.cursorword_disable_filetypes = {"NeogitStatus"}

