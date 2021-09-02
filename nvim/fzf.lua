local remap = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }

remap('n', '<C-f>', '<cmd>lua require("fzf-lua").files()<CR>', opts)
remap('n', "'", '<cmd>lua require("fzf-lua").buffers()<CR>', opts)
remap('n', 'gD', '<Cmd>lua require("fzf-lua").lsp_declarations()<CR>', opts)
remap('n', 'gd', '<Cmd>lua require("fzf-lua").lsp_definitions()<CR>', opts)
remap('n', 'gi', '<cmd>lua require("fzf-lua").lsp_implementations()<CR>', opts)
remap('n', '<space>D', '<cmd>lua require("fzf-lua").lsp_typedefs()<CR>', opts)
remap('n', '<leader>a', '<cmd>lua require("fzf-lua").lsp_code_actions()<CR>', opts)
remap('n', '<leader>u', '<cmd>lua require("fzf-lua").lsp_references()<CR>', opts)
remap('n', '<space>q', '<cmd>lua require("fzf-lua").lsp_document_diagnostics()<CR>', opts)
remap('n', '<space>qq', '<cmd>lua require("fzf-lua").lsp_workspace_diagnostics()<CR>', opts)
remap('n', '<space>s', '<cmd>lua require("fzf-lua").lsp_live_workspace_symbols()<CR>', opts)
remap('n', '<space>ss', '<cmd>lua require("fzf-lua").lsp_document_symbols()<CR>', opts)

local actions = require "fzf-lua.actions"
require'fzf-lua'.setup {
  winopts = {
    -- split         = "new",           -- open in a split instead?
    win_height       = 0.85,            -- window height
    win_width        = 0.80,            -- window width
    win_row          = 0.30,            -- window row position (0=top, 1=bottom)
    win_col          = 0.50,            -- window col position (0=left, 1=right)
    -- win_border    = false,           -- window border? or borderchars?
    win_border       = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    hl_normal        = 'Normal',        -- window normal color
    hl_border        = 'FloatBorder',   -- window border color
  },
  fzf_args            = vim.env.FZF_DEFAULT_OPTS, -- adv: fzf extra args, empty unless adv
  preview_border      = 'border',       -- border|noborder
  preview_wrap        = 'nowrap',       -- wrap|nowrap
  preview_opts        = 'nohidden',     -- hidden|nohidden
  preview_vertical    = 'down:45%',     -- up|down:size
  preview_horizontal  = 'right:60%',    -- right|left:size
  preview_layout      = 'flex',         -- horizontal|vertical|flex
  flip_columns        = 120,            -- #cols to switch to horizontal on flex
  default_previewer   = "bat",          -- override the default previewer?
                                        -- by default auto-detect bat|cat
  previewers = {
    bat = {
      cmd             = "bat",
      args            = "--style=numbers,changes --color always",
      theme           = vim.env.BAT_THEME, -- bat preview theme (bat --list-themes)
      config          = nil,               -- nil uses $BAT_CONFIG_PATH
    },
  },
  -- provider setup
  files = {
    previewer         = "bat",       -- uncomment to override previewer
    prompt            = 'Files❯ ',
    cmd               = '',             -- "find . -type f -printf '%P\n'",
    git_icons         = false,           -- show git icons?
    file_icons        = false,           -- show file icons?
    color_icons       = false,           -- colorize file|git icons
    actions = {
      ["default"]     = actions.file_edit,
      ["ctrl-s"]      = actions.file_split,
      ["ctrl-v"]      = actions.file_vsplit,
      ["ctrl-t"]      = actions.file_tabedit,
      ["ctrl-q"]      = actions.file_sel_to_qf,
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
    }
  },
  git = {
    files = {
      prompt          = 'GitFiles❯ ',
      cmd             = 'git ls-files --exclude-standard',
      git_icons       = false,           -- show git icons?
      file_icons      = false,           -- show file icons?
      color_icons     = false,           -- colorize file|git icons
    },
    status = {
      prompt        = 'GitStatus❯ ',
      cmd           = "git status -s",
      previewer     = "git_diff",
      file_icons    = false,
      git_icons     = false,
      color_icons   = false,
    },
    commits = {
      prompt          = 'Commits❯ ',
      cmd             = "git log --pretty=oneline --abbrev-commit --color",
      preview         = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
      actions = {
        ["default"] = nil,
      },
    },
    bcommits = {
      prompt          = 'BCommits❯ ',
      cmd             = "git log --pretty=oneline --abbrev-commit --color --",
      preview         = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
      actions = {
        ["default"] = nil,
      },
    },
    branches = {
      prompt          = 'Branches❯ ',
      cmd             = "git branch --all --color",
      preview         = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
      actions = {
        ["default"] = actions.git_switch,
      },
    },
    icons = {
      ["M"]           = { icon = "M", color = "yellow" },
      ["D"]           = { icon = "D", color = "red" },
      ["A"]           = { icon = "A", color = "green" },
      ["?"]           = { icon = "?", color = "magenta" },
      -- ["M"]          = { icon = "★", color = "red" },
      -- ["D"]          = { icon = "✗", color = "red" },
      -- ["A"]          = { icon = "+", color = "green" },
    },
  },
  grep = {
    prompt            = 'Rg❯ ',
    input_prompt      = 'Grep For❯ ',
    -- cmd               = "rg --vimgrep",
    rg_opts           = "--hidden --column --line-number --no-heading " ..
                        "--color=always --smart-case -g '!{.git,node_modules}/*'",
    git_icons         = false,           -- show git icons?
    file_icons        = false,           -- show file icons?
    color_icons       = false,           -- colorize file|git icons
    actions = {
      ["default"]     = actions.file_edit,
      ["ctrl-s"]      = actions.file_split,
      ["ctrl-v"]      = actions.file_vsplit,
      ["ctrl-t"]      = actions.file_tabedit,
      ["ctrl-q"]      = actions.file_sel_to_qf,
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
    }
  },
  oldfiles = {
    prompt            = 'History❯ ',
    cwd_only          = false,
  },
  buffers = {
    prompt            = 'Buffers❯ ',
    file_icons        = false,         -- show file icons?
    color_icons       = false,         -- colorize file|git icons
    sort_lastused     = true,         -- sort buffers() by last used
    actions = {
      ["default"]     = actions.buf_edit,
      ["ctrl-s"]      = actions.buf_split,
      ["ctrl-v"]      = actions.buf_vsplit,
      ["ctrl-t"]      = actions.buf_tabedit,
      ["ctrl-x"]      = actions.buf_del,
    }
  },
  colorschemes = {
    prompt            = 'Colorschemes❯ ',
    live_preview      = true,       -- apply the colorscheme on preview?
    actions = {
      ["default"]     = actions.colorscheme,
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
    },
    winopts = {
      win_height        = 0.55,
      win_width         = 0.30,
      window_on_create  = function()
        vim.cmd("set winhl=Normal:Normal")
      end,
    },
    post_reset_cb     = function()
      -- reset statusline highlights after
      -- a live_preview of the colorscheme
      -- require('feline').reset_highlights()
    end,
  },
  quickfix = {
    -- cwd               = vim.loop.cwd(),
    file_icons        = false,
    git_icons         = false,
  },
  lsp = {
    prompt            = '❯ ',
    -- cwd               = vim.loop.cwd(),
    cwd_only          = false,      -- LSP/diagnostics for cwd only?
    async_or_timeout  = true,       -- timeout(ms) or false for blocking calls
    file_icons        = false,
    git_icons         = false,
    lsp_icons         = false,
    severity          = "hint",
    icons = {
      ["Error"]       = { icon = "🄴 ", color = "red" },       -- error
      ["Warning"]     = { icon = "🅆 ", color = "yellow" },    -- warning
      ["Information"] = { icon = "🄸", color = "blue" },      -- info
      ["Hint"]        = { icon = "🄷", color = "magenta" },   -- hint
    },
  },
  -- placeholders for additional user customizations
  loclist = {},
  helptags = {},
  manpages = {},
  -- optional override of file extension icon colors
  -- available colors (terminal):
  --    clear, bold, black, red, green, yellow
  --    blue,magenta, cyan, grey, dark_grey, white
  file_icon_colors = {
    ["lua"]   = "blue",
  },
} 


