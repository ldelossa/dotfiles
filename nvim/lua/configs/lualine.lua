local gps = require("nvim-gps")

local hide_in_width = function(width)
    return function()
        return vim.fn.winwidth(0) > width
    end
end

local gps_hide_in_width = function()
    return gps.is_available() and hide_in_width(90)()
end

local branch = {
    'branch',
    cond = hide_in_width(80)
}
local diagnostics = {
    'diagnostics',
    sources = {'nvim_diagnostic'},
    cond = hide_in_width(80)
}
local gps_comp = {
    gps.get_location,
    cond = gps_hide_in_width
}
local diff = {
    'diff',
    cond = hide_in_width(100)
}
local filetype = {
    'filetype',
    cond = hide_in_width(100)
}
local filename = {
    'filename',
    path = 1
}
local progress = {
    'progress',
    cond = hide_in_width(100)
}
local location = {
    'location',
    cond = hide_in_width(40)
}

local function attached_lsp()
    local clients = vim.lsp.get_active_clients()
    if #clients > 0 then
        return clients[1].name
    end
    return ""
end

local active_lsp = {
    attached_lsp,
    icon = '',
    cond = function() return #vim.lsp.get_active_clients() > 0 and hide_in_width(100)() end
}

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'nightfox',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {},
    lualine_c = {branch, active_lsp, filename, gps_comp},
    lualine_x = {diff, diagnostics, filetype},
    lualine_y = {},
    lualine_z = {progress, location}
  },
  inactive_sections = {
    lualine_a = {'filename'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {}
}
