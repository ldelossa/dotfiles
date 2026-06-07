-- =============================================================================
-- WezTerm Configuration — mirrored from kitty
-- =============================================================================

local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

-- =============================================================================
-- Font & Appearance
-- =============================================================================

config.font = wezterm.font {
  family = 'FiraMono Nerd Font Mono',
  weight = 'Medium',
}
config.font_size = 12.0
config.adjust_window_size_when_changing_font_size = false

-- Ghostty uses font-thicken=true on macOS. WezTerm doesn't expose an exact
-- equivalent, but light hinting + LCD rendering gives a slightly fuller,
-- smoother result while preserving the same font family and size.
config.freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- =============================================================================
-- Color schemes (kitty dark + light, auto-switch based on macOS appearance)
-- =============================================================================

config.color_schemes = {
  -- Dark theme (matched from kitty themes/dark-theme.conf)
  ['kitty-dark'] = {
    foreground = '#E4E4E4',
    background = '#22272e',
    cursor_bg = '#87AFD7',
    cursor_fg = '#1F1F1F',
    ansi = {
      '#5E5C64', '#CF6A4C', '#87AF87', '#D7934F',
      '#87AFD7', '#988ACF', '#4DC5C6', '#949494',
    },
    brights = {
      '#5E5C64', '#CF6A4C', '#87AF87', '#756643',
      '#87AFD7', '#806CCF', '#268889', '#FFFFFF',
    },
    selection_bg = '#87AFD7',
    selection_fg = '#1F1F1F',
    split = '#3a3a3a',
    tab_bar = {
      background = '#1a1e24',
      inactive_tab_edge = '#355f72',
      active_tab = {
        bg_color = '#5eaddf', fg_color = '#111111', intensity = 'Bold',
      },
      inactive_tab = {
        bg_color = '#1a1e24', fg_color = '#5b6e7a',
      },
      inactive_tab_hover = {
        bg_color = '#2a3340', fg_color = '#8ba0b0',
      },
      new_tab = {
        bg_color = '#1a1e24', fg_color = '#5b6e7a',
      },
      new_tab_hover = {
        bg_color = '#2a3340', fg_color = '#8ba0b0',
      },
    },
  },

  -- Light theme (matched from kitty themes/light-theme.conf)
  ['kitty-light'] = {
    foreground = '#262626',
    background = '#f0f0f0',
    cursor_bg = '#437790',
    cursor_fg = '#B9BAB5',
    ansi = {
      '#262626', '#AF5F5F', '#497964', '#756643',
      '#437790', '#806CCF', '#268889', '#262626',
    },
    brights = {
      '#484848', '#AF5F5F', '#497964', '#c6823e',
      '#437790', '#988ACF', '#24a0a0', '#555555',
    },
    selection_bg = '#437790',
    selection_fg = '#ffffff',
    split = '#d0d0d0',
    tab_bar = {
      background = '#d6e4ea',
      inactive_tab_edge = '#aac3cf',
      active_tab = {
        bg_color = '#437790', fg_color = '#ffffff', intensity = 'Bold',
      },
      inactive_tab = {
        bg_color = '#e8eef1', fg_color = '#555555',
      },
      inactive_tab_hover = {
        bg_color = '#c8d8df', fg_color = '#262626',
      },
      new_tab = {
        bg_color = '#e8eef1', fg_color = '#888888',
      },
      new_tab_hover = {
        bg_color = '#c8d8df', fg_color = '#262626',
      },
    },
  },
}

-- Quick Select: high-contrast labels (defaults blend into dark themes)
config.colors = {
  quick_select_label_bg = { Color = '#ffa500' },  -- vivid orange bg
  quick_select_label_fg = { Color = '#000000' },  -- black text on orange
  quick_select_match_bg = { Color = '#87AFD7' },   -- subtle blue match highlight
  quick_select_match_fg = { Color = '#1F1F1F' },   -- dark text on blue
}
config.quick_select_remove_styling = true  -- strip all pane colors during Quick Select

-- Auto-switch between light/dark based on macOS system appearance.
-- WezTerm detects appearance changes and reloads the config automatically.
function scheme_for_appearance(appearance)
  if appearance:find('Dark') then
    return 'kitty-dark'
  else
    return 'kitty-light'
  end
end

function tab_colors_for_appearance(appearance)
  if appearance:find('Dark') then
    return {
      bar_bg = '#1a1e24',
      bar_fg = '#E4E4E4',
      active_bg = '#5eaddf',   -- sky blue
      active_fg = '#111111',
      inactive_bg = '#1a1e24',   -- merge into bar background
      inactive_fg = '#5b6e7a',   -- dim, muted blue-gray
      hover_bg = '#2a3340',
      hover_fg = '#8ba0b0',
      border = '#355f72',
    }
  else
    return {
      bar_bg = '#d6e4ea',
      bar_fg = '#262626',
      active_bg = '#437790',
      active_fg = '#ffffff',
      inactive_bg = '#e8eef1',
      inactive_fg = '#555555',
      hover_bg = '#c8d8df',
      hover_fg = '#262626',
      border = '#aac3cf',
    }
  end
end

function window_frame_for_appearance(appearance)
  local tab = tab_colors_for_appearance(appearance)

  return {
    font = wezterm.font { family = 'FiraMono Nerd Font Mono', weight = 'Medium' },
    font_size = 10.0,
    active_titlebar_bg = tab.bar_bg,
    inactive_titlebar_bg = tab.bar_bg,
    active_titlebar_fg = tab.bar_fg,
    inactive_titlebar_fg = tab.inactive_fg,
    active_titlebar_border_bottom = tab.border,
    inactive_titlebar_border_bottom = tab.bar_bg,
    button_fg = tab.bar_fg,
    button_bg = tab.bar_bg,
    button_hover_fg = tab.active_fg,
    button_hover_bg = tab.active_bg,
  }
end

local function ssh_auth_sock_from_agent_file()
  local agent_file = wezterm.home_dir .. '/.ssh-agent'
  local file = io.open(agent_file, 'r')
  if not file then
    return nil
  end

  local contents = file:read '*a'
  file:close()

  local sock = contents:match 'SSH_AUTH_SOCK=([^;]+);'
  if sock and #wezterm.glob(sock) == 1 then
    return sock
  end

  return nil
end

local appearance = wezterm.gui and wezterm.gui.get_appearance() or 'Dark'
local ssh_auth_sock = ssh_auth_sock_from_agent_file()

config.color_scheme = scheme_for_appearance(appearance)
config.window_frame = window_frame_for_appearance(appearance)
if ssh_auth_sock then
  config.default_ssh_auth_sock = ssh_auth_sock
end

-- =============================================================================
-- Behavior
-- =============================================================================

config.default_prog = { 'zsh', '-l' }
config.hide_mouse_cursor_when_typing = true
config.pane_focus_follows_mouse = true
config.audible_bell = 'Disabled'
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.window_close_confirmation = 'AlwaysPrompt'
config.exit_behavior = 'Close'
config.window_decorations = 'RESIZE'

-- =============================================================================
-- SSH domain for Linux VM (alt+return opens a window where all new tabs
-- automatically reuse the same SSH connection, no remote daemon needed)
-- =============================================================================

config.ssh_domains = {
  {
    name = 'linux',
    remote_address = 'linux',     -- from ~/.ssh/config
    multiplexing = 'None',        -- plain SSH, no remote wezterm needed
    assume_shell = 'Posix',       -- enables CWD tracking for new panes
    ssh_option = ssh_auth_sock and {
      identityagent = ssh_auth_sock,
    } or nil,
  },
}

-- =============================================================================
-- Tab title formatting — show ⇪ when a split is zoomed (matching kitty)
-- =============================================================================

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end

  -- The panes argument is for the active tab in the window, not necessarily
  -- the tab currently being formatted. Look up this tab's own panes so the
  -- zoom marker only appears on the tab with the zoomed pane.
  local mux_tab = wezterm.mux.get_tab(tab.tab_id)
  if mux_tab then
    for _, pane_info in ipairs(mux_tab:panes_with_info()) do
      if pane_info.is_zoomed then
        title = '⇪ ' .. title
        break
      end
    end
  end

  -- Fancy tab bars don't reliably honor color_schemes[].tab_bar colors.
  -- Force the label colors here so the selected tab doesn't fall back to the
  -- native black/white appearance.
  local tab_colors = tab_colors_for_appearance(wezterm.gui.get_appearance())
  local bg = tab_colors.inactive_bg
  local fg = tab_colors.inactive_fg
  local intensity = 'Normal'

  if tab.is_active then
    bg = tab_colors.active_bg
    fg = tab_colors.active_fg
    intensity = 'Bold'
  elseif hover then
    bg = tab_colors.hover_bg
    fg = tab_colors.hover_fg
  end

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Attribute = { Intensity = intensity } },
    { Text = ' ' .. title .. ' ' },
  }
end)

-- Force tab bar to re-render after config reloads (auto-reload can leave
-- stale format-tab-title handlers first in the callback list).
wezterm.on('window-config-reloaded', function(window)
  local overrides = window:get_config_overrides() or {}
  window:set_config_overrides(overrides)
end)

-- Keep the yabai scratchpad rule stable even if the shell updates the pane title.
-- The skhd scratchpad binding launches WezTerm into this workspace.
wezterm.on('format-window-title', function(tab, pane, tabs, panes, effective_config)
  local mux_window = nil
  if tab.window_id then
    mux_window = wezterm.mux.get_window(tab.window_id)
  end

  if mux_window and mux_window:get_workspace() == 'scratchpad' then
    return 'scratchpad'
  end

  local zoomed = ''
  if tab.active_pane.is_zoomed then
    zoomed = '[Z] '
  end

  local index = ''
  if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
  end

  return zoomed .. index .. tab.active_pane.title
end)

-- =============================================================================
-- Keybindings — replicated from kitty
-- =============================================================================
-- Note on split naming (they're reversed between the two terminals):
--   kitty hsplit = horizontal divider, top/bottom panes → WezTerm SplitVertical
--   kitty vsplit = vertical divider, left/right panes   → WezTerm SplitHorizontal
--   WezTerm also supports mouse-drag on the divider to resize splits.

config.keys = {
  -- ---------------------------------------------------------------------------
  -- Tabs
  -- ---------------------------------------------------------------------------
  -- kitty: ctrl+alt+t  /  alt+shift+t  →  new_tab
  { key = 't', mods = 'CTRL|ALT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 't', mods = 'SHIFT|ALT', action = act.SpawnTab 'CurrentPaneDomain' },

  -- kitty: ctrl+alt+n  /  ctrl+alt+p  →  next_tab / previous_tab
  { key = 'n', mods = 'CTRL|ALT', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'CTRL|ALT', action = act.ActivateTabRelative(-1) },

  -- kitty: ctrl+alt+w  →  close_tab
  { key = 'w', mods = 'CTRL|ALT', action = act.CloseCurrentTab { confirm = true } },
  -- ctrl+alt+q  →  close current pane
  { key = 'q', mods = 'CTRL|ALT', action = act.CloseCurrentPane { confirm = true } },

  -- kitty: ctrl+alt+,  →  set_tab_title (prompts for a new tab name)
  { key = ',', mods = 'CTRL|ALT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- kitty: ctrl+alt+o  /  ctrl+alt+i  →  move_tab_forward / backward
  { key = 'o', mods = 'CTRL|ALT', action = act.MoveTabRelative(1) },
  { key = 'i', mods = 'CTRL|ALT', action = act.MoveTabRelative(-1) },

  -- kitty: alt+tab  →  goto_tab -1 (last active tab)
  { key = 'Tab', mods = 'ALT', action = act.ActivateLastTab },

  -- Ghostty alternates: shift+ctrl+alt+h/l  →  prev/next tab
  { key = 'h', mods = 'SHIFT|CTRL|ALT', action = act.ActivateTabRelative(-1) },
  { key = 'l', mods = 'SHIFT|CTRL|ALT', action = act.ActivateTabRelative(1) },

  -- ---------------------------------------------------------------------------
  -- Windows
  -- ---------------------------------------------------------------------------
  -- kitty: alt+shift+enter  /  ctrl+alt+enter  /  ctrl+alt+shift+n  →  new_os_window
  { key = 'Enter', mods = 'SHIFT|ALT',    action = act.SpawnWindow },
  { key = 'Enter', mods = 'CTRL|ALT',     action = act.SpawnWindow },
  { key = 'n',     mods = 'CTRL|ALT|SHIFT', action = act.SpawnWindow },

  -- ---------------------------------------------------------------------------
  -- Named layouts (spawn multiple SSH tabs at once)
  -- ---------------------------------------------------------------------------
  -- ctrl+alt+shift+w  →  open work tabs on linux
  { key = 'w', mods = 'CTRL|ALT|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local mux_window = window:mux_window()
      if not mux_window then
        return
      end

      local original_tab = pane:tab()

      for _, t in ipairs({
        { label = 'cilium',  cwd = '/home/louis/git/gopath/src/github.com/cilium/cilium-enterprise' },
        { label = 'cilium2', cwd = '/home/louis/git/gopath/src/github.com/cilium/cilium-enterprise-1' },
        { label = 'cilium3', cwd = '/home/louis/git/gopath/src/github.com/cilium/cilium-enterprise-2' },
        { label = 'testing', cwd = '/home/louis/git/isovalent/cilium-testing' },
        { label = 'kernel',  cwd = '/home/louis/git/c/linux-bpf-next' },
      }) do
        local tab = mux_window:spawn_tab {
          domain = { DomainName = 'linux' },
          cwd = t.cwd,
        }
        tab:set_title(t.label)
      end

      original_tab:activate()
      window:perform_action(act.CloseCurrentTab { confirm = false }, pane)
    end),
  },
  -- ctrl+alt+x  →  pi split (30% height bottom pane)
  { key = 'x', mods = 'CTRL|ALT',
    action = wezterm.action.SplitPane {
      direction = 'Down',
      size = { Percent = 30 },
      command = { args = { '/bin/zsh', '-i', '-l', '-c', 'exec pi' } },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Splits (creation)
  -- ---------------------------------------------------------------------------
  -- kitty: ctrl+alt+s  →  launch --location=hsplit (top/bottom panes)
  { key = 's', mods = 'CTRL|ALT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- kitty: ctrl+alt+v  →  launch --location=vsplit (left/right panes)
  { key = 'v', mods = 'CTRL|ALT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- kitty: ctrl+alt+z  →  toggle_layout stack  (zoom closest equivalent)
  -- ScrollToBottom after zoom to work around wezterm#2987 (zoom drifts into
  -- scrollback on macOS instead of preserving bottom gravity).
  { key = 'z', mods = 'CTRL|ALT',
    action = act.Multiple {
      act.TogglePaneZoomState,
      act.ScrollByPage(999),
    },
  },

  -- Ghostty alternates: shift+alt+s/v/z
  { key = 's', mods = 'SHIFT|ALT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'v', mods = 'SHIFT|ALT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'z', mods = 'SHIFT|ALT',
    action = act.Multiple {
      act.TogglePaneZoomState,
      act.ScrollByPage(999),
    },
  },

  -- ---------------------------------------------------------------------------
  -- Split navigation (vim-style: h=left, j=down, k=up, l=right)
  -- ---------------------------------------------------------------------------
  -- kitty: ctrl+alt+h/j/k/l  →  neighboring_window left/down/up/right
  { key = 'h', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Right' },

  -- Ghostty alternates: shift+alt+h/j/k/l
  { key = 'h', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Right' },

  -- ---------------------------------------------------------------------------
  -- Split resizing
  -- ---------------------------------------------------------------------------
  -- kitty: ctrl+alt+arrows  →  resize_window narrower/wider/taller/shorter
  { key = 'LeftArrow',  mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow',    mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow',  mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Down', 5 } },

  -- ---------------------------------------------------------------------------
  -- Scroll / Prompt navigation
  -- ---------------------------------------------------------------------------
  -- kitty: ctrl+alt+u/d  →  scroll_page_up/down
  { key = 'u', mods = 'CTRL|ALT', action = act.ScrollByPage(-1) },
  { key = 'd', mods = 'CTRL|ALT', action = act.ScrollByPage(1) },

  -- kitty: ctrl+alt+shift+p/n  →  scroll_to_prompt -1/+1
  { key = 'p', mods = 'CTRL|ALT|SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'n', mods = 'CTRL|ALT|SHIFT', action = act.ScrollToPrompt(1) },

  -- ctrl+shift+l  →  fuzzy tab search
  { key = 'L', mods = 'CTRL|SHIFT', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS' } },

  -- Named workspace (session) creation: prompt and switch
  {
    key = 'W', mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter name for new workspace',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },

  -- Ghostty alternates: shift+alt+p/n  →  jump_to_prompt
  { key = 'p', mods = 'SHIFT|ALT', action = act.ScrollToPrompt(-1) },
  { key = 'n', mods = 'SHIFT|ALT', action = act.ScrollToPrompt(1) },

  -- ---------------------------------------------------------------------------
  -- Font size (matching kitty: cmd+plus, cmd+equal, cmd+minus)
  -- ---------------------------------------------------------------------------
  { key = '+', mods = 'SUPER', action = act.IncreaseFontSize },
  { key = '=', mods = 'SUPER', action = act.IncreaseFontSize },
  { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },
  { key = '0', mods = 'SUPER', action = act.ResetFontSize },
}

-- =============================================================================
-- Notes on things that could NOT be replicated from kitty:
--

-- - ctrl+alt+r  →  start_resizing_window: WezTerm has no resize mode; use
--                   keyboard (AdjustPaneSize) or mouse-drag on the divider
-- - ctrl+alt+shift+h/l/k/j  →  move_window: WezTerm has no move_split action
-- - alt+shift+x  →  focus_visible_window: no WezTerm equivalent
-- - alt+space    →  tab-select.sh (fzf overlay): no WezTerm equivalent
-- - ctrl+shift+{a-z}  →  send_text escape sequences:
--                   WezTerm supports the kitty keyboard protocol natively.
--
--   For vim/fzf compatibility: ctrl+shift+v is sent through to the terminal
--   (kitty's no_op equivalent) so fzf.vim can receive it. Other ctrl+shift+letter
--   combos pass through by default since WezTerm doesn't bind them.
-- =============================================================================

return config
