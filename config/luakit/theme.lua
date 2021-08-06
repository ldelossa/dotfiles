--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

local black = "#393E41"
local offwhite = "#D3D0CB"
local yellow = "#F4D35E"
local lightblue = "#759FBC"
local blue = "#0D3B66"
local blacker = "#1E2019"
local orange = "#FA9F42"

-- Default settings
theme.font = "14px monospace"
theme.fg   = "#000"
theme.bg   = "#fff"

-- Genaral colours
theme.success_fg = "#0f0"
theme.loaded_fg  = "#33AADD"
theme.error_fg = "#FFF"
theme.error_bg = "#F00"

-- Warning colours
theme.warning_fg = "#F00"
theme.warning_bg = "#FFF"

-- Notification colours
theme.notif_fg = "#444"
theme.notif_bg = "#FFF"

-- Menu colours
theme.menu_fg                   = "#999"
theme.menu_bg                   = "#eee"
theme.menu_selected_fg          = "#fff"
theme.menu_selected_bg          = lightblue
theme.menu_title_bg             = yellow
theme.menu_primary_title_fg     = blacker
theme.menu_secondary_title_fg   = "#666"

theme.menu_disabled_fg = "#999"
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = yellow
theme.menu_active_bg = theme.menu_bg

-- Proxy manager
theme.proxy_active_menu_fg      = '#000'
theme.proxy_active_menu_bg      = '#FFF'
theme.proxy_inactive_menu_fg    = '#888'
theme.proxy_inactive_menu_bg    = '#FFF'

-- Statusbar specific
theme.sbar_fg         = "#fff"
theme.sbar_bg         = lightblue

-- Downloadbar specific
theme.dbar_fg         = "#fff"
theme.dbar_bg         = "#000"
theme.dbar_error_fg   = "#F00"

-- Input bar specific
theme.ibar_fg           = "#FFF"
theme.ibar_bg           = black

-- Tab label
theme.tab_fg            = "#888"
theme.tab_bg            = "#fff"
theme.tab_hover_bg      = yellow
theme.tab_ntheme        = "#ddd"
theme.selected_fg       = "#fff"
theme.selected_bg       = lightblue
theme.selected_ntheme   = "#ddd"
theme.loading_fg        = "#33AADD"
theme.loading_bg        = "#000"

theme.selected_private_tab_bg = "#3d295b"
theme.private_tab_bg    = "#22254a"

-- Trusted/untrusted ssl colours
theme.trust_fg          = orange
theme.notrust_fg        = "#F00"

-- Follow mode hints
theme.hint_font = "10px monospace, courier, sans-serif"
theme.hint_fg = yellow
theme.hint_bg = lightblue
theme.hint_border = ".3px solid #000"
theme.hint_opacity = "0.3"
theme.hint_overlay_bg = "rgba(255,255,153,0.3)"
theme.hint_overlay_border = "1px dotted #000"
theme.hint_overlay_selected_bg = "rgba(0,255,0,0.3)"
theme.hint_overlay_selected_border = theme.hint_overlay_border

-- General colour pairings
theme.ok = { fg = "#000", bg = "#FFF" }
theme.warn = { fg = "#F00", bg = "#FFF" }
theme.error = { fg = "#FFF", bg = "#F00" }

-- Gopher page style (override defaults)
theme.gopher_light = { bg = "#E8E8E8", fg = "#17181C", link = "#03678D" }
theme.gopher_dark  = { bg = "#17181C", fg = "#E8E8E8", link = "#f90" }

return theme

-- vim: et:sw=4:ts=8:sts=4:tw=80
