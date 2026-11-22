local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.use_ime = true
config.ime_preedit_rendering = "Builtin"
config.xim_im_name = 'fcitx'
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = true
config.show_tabs_in_tab_bar = true
config.default_cursor_style = "SteadyBar"
-- config.default_prog = { 'C:\\Program Files\\Git\\bin\\bash.exe', '-i', '-l' }
config.audible_bell = "Disabled"
config.window_close_confirmation = 'NeverPrompt'
config.keys = {
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab {confirm = false},
  },
}

config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
  'tmux',
  'nu',
  'ssh',
}

wezterm.on('mux-is-process-stateful', function(proc)
  return false
end)

config.window_frame = {
  active_titlebar_bg = "#03181D",
  inactive_titlebar_bg = "#03181D",
  active_titlebar_fg = "#FFFFFF",
  inactive_titlebar_fg = "#888888",
}

config.window_background_gradient = {
  colors = { "#03181D" },
}

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)


-- フォント
config.font = wezterm.font('Firple')
config.font_size = 12.0

-- カラースキーム
config.color_scheme = 'Dark+'
config.colors = {
  selection_fg = '#1e1e1e',
  selection_bg = 'rgba(255, 255, 255, 0.8)'
}

-- 透過
config.window_background_opacity = 0.85

return config
