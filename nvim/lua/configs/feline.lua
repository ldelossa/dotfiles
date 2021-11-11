local gps = require("nvim-gps")

local colors = {}
if vim.g.colors_name == "vimdark" then
    colors = { 
        bg = '#262626',
        fg = "#e4e4e4",
        blue = '#0087af',
        yellow = '#ffff5f',
        green = '#87af87',
        grey = '#e4e4e4'
    }
else 
    colors = { 
        fg = '#3a3a3a',
        bg = "#e4e4e4",
        blue = '#005f87',
        yellow = '#ffff5f',
        green = '#87af87',
        grey = '#4a4a4a'
    }
end

local vi_mode_utils = require('feline.providers.vi_mode')

local comp = {
    active = {},
    inactive = {}
}

comp.active[1] = {
    {
        provider = ' ',
    },
    {
        provider = 'vi_mode',
        hl = function()
            return {
                name = vi_mode_utils.get_mode_highlight_name(),
                fg = vi_mode_utils.get_mode_color(),
                style = 'bold'
            }
        end,
        right_sep = ' ',
        left_sep = ' '
    },
    {
        provider = {
            name ='file_info',
            opts = {
                type = 'relative'
            }
        },
        short_provider = {
            name ='file_info',
            opts = {
                type = 'base-only'
            }
        },
        hl = {
            fg = 'bg',
            bg = colors.grey 
        },
        left_sep = {
            ' ', 
            {str = ' ', 
            hl = { fg = 'bg', bg = colors.grey}}
        },
        right_sep = {'slant_right', ' '},
    },
    {
        provider = 'position',
        right_sep = {
            ' ',
            {
                str = 'slant_left_2_thin',
                hl = {
                    fg = 'fg',
                    bg = 'bg'
                }
            }
        },
    },
    {
        provider = 'lsp_client_names',
        short_provider = '',
        right_sep = {
            ' ',
            {
                str = 'slant_left_2_thin',
                hl = {
                    fg = 'fg',
                    bg = 'bg'
                }
            }
        },
        left_sep = {
            ' ', 
            {str = ' ', hl = {fg = 'fg', bg = 'bg'}}
        },
    },
    {
        provider = function()
		    return gps.get_location()
	        end,
	    enabled = function()
		    return gps.is_available()
	        end,
        short_provider = '',
        right_sep = {
            ' ',
            {
                str = 'slant_left_2_thin',
                hl = {
                    fg = 'fg',
                    bg = 'bg'
                }
            }
        },
        left_sep = {
            ' ', 
            {str = ' ', hl = {fg = 'fg', bg = 'bg'}}
        },
    },
    {
        provider = 'diagnostic_errors',
        hl = { fg = 'red' }
    },
    {
        provider = 'diagnostic_warnings',
        hl = { fg = 'orange' }
    },
    {
        provider = 'diagnostic_hints',
        hl = { fg = colors.blue }
    },
    {
        provider = 'diagnostic_info',
        hl = { fg = colors.blue }
    }
}

comp.active[2] = {
    {
        provider = 'git_branch',
        hl = {
            fg = colors.fg,
            bg = colors.bg,
            style = 'bold'
        },
        short_provider = '',
        right_sep = {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = colors.bg
            }
        }
    },
    {
        provider = 'git_diff_added',
        hl = {
            fg = colors.green,
            bg = colors.bg,
        }
    },
    {
        provider = 'git_diff_changed',
        hl = {
            fg = 'orange',
            bg = colors.bg,
        }
    },
    {
        provider = 'git_diff_removed',
        hl = {
            fg = 'red',
            bg = colors.bg,
        },
        right_sep = {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = colors.bg,
            }
        }
    },
    {
        provider = 'scroll_bar',
        short_provider = '',
        left_sep = '  ',
        right_sep = ' ',
        hl = {
            fg = colors.blue,
            bg = colors.bg,
        },
    }
}

comp.inactive[1] = {
    {
        provider = 'file_info',
        hl = { fg = 'bg', bg = 'fg'},
        left_sep = {
            ' ', 
            {str = ' ', 
            hl = { fg = 'bg', bg = 'fg'}}
        },
        right_sep = {'slant_right', ' '},

    },
    -- Empty component to fix the highlight till the end of the statusline
    {
    }
}

require('feline').setup({
    colors = colors,
    components = comp
})
