local wezterm = require('wezterm')

local function file_exists(path)
  local f = io.open(path, 'r')

  if f then
    f:close()
    return true
  end

  return false
end

-- restore wezterm icon on start if it is missing (e.g. after upgrade)
wezterm.on('gui-startup', function(cmd)
  -- Required when hooking gui-startup so WezTerm still opens the default window
  wezterm.mux.spawn_window(cmd or {})

  local app_path = '/Applications/WezTerm.app'
  local icon_path = wezterm.home_dir .. '/prefix/usr/local/icons/terminal.icns'
  local fileicon_bin = '/opt/homebrew/bin/fileicon'

  -- fileicon creates 'Icon\r' inside the .app bundle when a custom icon is set
  if file_exists(app_path .. '/Icon\r') then
    return
  end

  if not file_exists(fileicon_bin) then
    wezterm.run_child_process({ '/opt/homebrew/bin/brew', 'install', 'fileicon' })
  end

  wezterm.run_child_process({ '/opt/homebrew/bin/fileicon', 'set', app_path, icon_path })
  wezterm.run_child_process({ 'killall', 'Dock' })
end)

local config = wezterm.config_builder()

config.color_scheme = 'Tokyo Night'
config.font = wezterm.font('Terminess Nerd Font Mono')
config.font_size = 12.0
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 120
config.animation_fps = 120

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

config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[\b(go/[a-zA-Z0-9-_./]+)]],
  format = 'https://$1',
})

table.insert(config.hyperlink_rules, {
  regex = [[\b(b/[0-9]+)]],
  format = 'http://$1',
})

table.insert(config.hyperlink_rules, {
  regex = [[\b(doc/[a-zA-Z0-9-_]+)]],
  format = 'https://$1',
})

table.insert(config.hyperlink_rules, {
  regex = [[\b(fxbug\.dev/[0-9]+)]],
  format = 'https://$1',
})

table.insert(config.hyperlink_rules, {
  regex = [[\b(pwbug\.dev/[0-9]+)]],
  format = 'https://$1',
})

table.insert(config.hyperlink_rules, {
  regex = [[\b(fxrev\.dev/[0-9]+)]],
  format = 'https://$1',
})

table.insert(config.hyperlink_rules, {
  regex = [[\b(fxr/[0-9]+)]],
  format = 'http://$1',
})

table.insert(config.hyperlink_rules, {
  regex = [[\b(pwrev\.dev/[0-9]+)]],
  format = 'https://$1',
})


return config
