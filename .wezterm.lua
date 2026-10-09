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

-- WezTerm versions before 2025-02-23 (including stable 20240203-110809-5046fc22)
-- have an off-by-one bug in get_text_from_semantic_zone (`this_row < last_row`
-- instead of `<= last_row`, fixed in commit 0f21892b).
local needs_y_offset_workaround = wezterm.version < '20250223'

local function get_zone_text(pane, start_zone, end_zone)
  end_zone = end_zone or start_zone
  local y_offset = needs_y_offset_workaround and 1 or 0
  local text = pane:get_text_from_region(
    start_zone.start_x,
    start_zone.start_y,
    end_zone.end_x,
    end_zone.end_y + y_offset
  )
  return (text or ''):gsub('%s+$', '')
end

local function find_last_command_zones(pane, include_prompt)
  local zones = pane:get_semantic_zones()
  if not zones or #zones == 0 then
    return nil, nil, 'No semantic zones found'
  end

  for i = #zones, 1, -1 do
    if zones[i].semantic_type == 'Output' and get_zone_text(pane, zones[i]) ~= '' then
      local output_zone = zones[i]
      local start_zone = output_zone

      if zones[i - 1] and zones[i - 1].semantic_type == 'Input' then
        start_zone = zones[i - 1]
        if include_prompt and zones[i - 2] and zones[i - 2].semantic_type == 'Prompt' then
          start_zone = zones[i - 2]
        end
      end

      return start_zone, output_zone, nil
    end
  end

  return nil, nil, 'Output zone is empty'
end

local function copy_last_command_and_output(window, pane)
  local include_prompt = true
  local start_zone, output_zone, err = find_last_command_zones(pane, include_prompt)
  if err then
    window:toast_notification('WezTerm', err, nil, 1500)
    return
  end

  local text = get_zone_text(pane, start_zone, output_zone)
  window:copy_to_clipboard(text, 'Clipboard')

  if needs_y_offset_workaround then
    window:toast_notification('WezTerm', 'Copied command and output!', nil, 1500)
  else
    window:toast_notification(
      'WezTerm',
      'Copied! (WezTerm upgraded: you can remove the y_offset workaround in ~/.wezterm.lua)',
      nil,
      4000
    )
  end
end

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
    key = 'o',
    mods = 'CTRL',
    action = wezterm.action.QuickSelect,
  },
  {
    key = 'i',
    mods = 'CTRL',
    action = wezterm.action.ActivateCopyMode,
  },
  {
    key = 'i',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(copy_last_command_and_output),
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
