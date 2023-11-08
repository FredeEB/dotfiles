local wezterm = require('wezterm')
local tmux = require('tmux')


local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Tokyo Night'
config.font = wezterm.font('Iosevka Nerd Font')
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.enable_tab_bar = false

config.default_prog = tmux.tmux_command()

return config

