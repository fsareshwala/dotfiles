local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.color_scheme = 'Tokyo Night'
config.font = wezterm.font('Terminess Nerd Font Mono')
config.font_size = 12.0

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.pane_focus_follows_mouse = true

config.keys = {
  {
    key = 'Enter',
    mods = 'SUPER',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = 'Enter',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = 'c',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },
  {
    key = 'j',
    mods = 'SUPER',
    action = wezterm.action.ActivatePaneDirection('Next'),
  },
  {
    key = 'k',
    mods = 'SUPER',
    action = wezterm.action.ActivatePaneDirection('Prev'),
  },
  {
    key = 'j',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.RotatePanes('Clockwise'),
  },
  {
    key = 'k',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.RotatePanes('CounterClockwise'),
  },
  {
    key = 'i',
    mods = 'CTRL',
    action = wezterm.action.QuickSelect,
  },
  {
    key = 'i',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateCopyMode,
  },
}

return config
