local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

--------------------------------------------------------------------------------
-- 1. LOGIC & FUNCTIONS
--------------------------------------------------------------------------------

local is_maximized = false

-- Smart Copy: Copy if text is selected, otherwise send Ctrl+C to terminal
local function smart_copy(window, pane)
  local selection = window:get_selection_text_for_pane(pane)
  if selection ~= "" then
    window:perform_action(act.CopyTo 'Clipboard', pane)
    window:perform_action(act.ClearSelection, pane)
  else
    window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
  end
end

-- Centered Startup Event (Native Linux version)
wezterm.on('gui-startup', function(cmd)
  local screen = wezterm.gui.screens().main
  
  -- Pixel dimensions for Fira Code @ size 11 (Debian DPI)
  local cell_width = 9 
  local cell_height = 20
  
  local pixel_width = (150 * cell_width) + 40
  local pixel_height = (35 * cell_height) + 20
  
  local x = (screen.width - pixel_width) / 2
  local y = (screen.height - pixel_height) / 2

  wezterm.mux.spawn_window {
    position_x = x,
    position_y = y,
    width = 150,
    height = 35,
    args = cmd and cmd.args
  }
end)

--------------------------------------------------------------------------------
-- 2. MAIN CONFIGURATION
--------------------------------------------------------------------------------

-- Linux Native Defaults
-- No default_domain needed for native Debian; it will use your system's $SHELL (Zsh)
config.default_cwd = "~"
config.initial_cols = 120
config.initial_rows = 35

-- Font Settings
config.font = wezterm.font_with_fallback({
  'CaskaydiaCove Nerd Font',
  'Symbols Nerd Font Mono',
})
config.font_size = 11.0

-- Visual Style (Optimized for Linux)
config.color_scheme = 'Tokyo Night'
config.window_background_opacity = 0.85
-- On Linux, decorations "RESIZE" works best with GNOME/KDE
config.window_decorations = "NONE" 
config.use_fancy_tab_bar = false
-- config.window_decorations = "TITLE | RESIZE"
config.window_padding = { 
  left = '1cell', 
  right = '1cell', 
  top = '0.5cell', 
  bottom = '0cell' 
}

-- Cursor & Tab Bar
config.default_cursor_style = 'SteadyBar'
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false

--------------------------------------------------------------------------------
-- 3. KEYBINDINGS
--------------------------------------------------------------------------------

config.keys = {
  -- Toggle Maximize/Restore
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action_callback(function(window, pane)
      if is_maximized then
        window:restore()
        is_maximized = false
      else
        window:maximize()
        is_maximized = true
      end
    end),
  },

  -- Smart Ctrl+C
  {
    key = 'c',
    mods = 'CTRL',
    action = wezterm.action_callback(smart_copy),
  },

  -- Standard Ctrl+V
  {
    key = 'v',
    mods = 'CTRL',
    action = act.PasteFrom 'Clipboard',
  },
}

return config