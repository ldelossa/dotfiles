local remap = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }

-- fzf
remap('n', '<C-f>', '<cmd>lua require("fzf-lua").files()<CR>', opts)
remap('c', '<C-f>', '<cmd>lua require("fzf-lua").command_history()<CR><CR>', opts)
remap('n', "'", '<cmd>lua require("fzf-lua").buffers()<CR>', opts)
remap('n', '<space>g', '<cmd>lua require("fzf-lua").live_grep()<CR>', opts)
remap('n', '<space>gg', '<cmd>lua require("fzf-lua").grep_cword()<CR>', opts)
remap('n', '<space>m', '<cmd>lua require("fzf-lua").marks()<CR>', opts)
remap('n', '<space>t', '<cmd>lua require("fzf-lua").tabs()<CR>', opts)
-- c-f (fzf) namespaced
remap('n', '<C-f>f', '<cmd>lua require("fzf-lua").files()<CR>', opts)
remap('c', '<C-f>f', '<cmd>lua require("fzf-lua").command_history()<CR><CR>', opts)
remap('n', "<C-f>'", '<cmd>lua require("fzf-lua").buffers()<CR>', opts)
remap('n', '<C-f>g', '<cmd>lua require("fzf-lua").live_grep()<CR>', opts)
remap('n', '<C-f>gg', '<cmd>lua require("fzf-lua").live_grep_resume()<CR>', opts)
remap('n', '<C-f>G', '<cmd>lua require("fzf-lua").grep()<CR>', opts)
remap('n', '<C-f>GG', '<cmd>lua require("fzf-lua").grep_resume()<CR>', opts)
remap('n', '<C-f>m', '<cmd>lua require("fzf-lua").marks()<CR>', opts)
remap('n', '<C-f>t', '<cmd>lua require("fzf-lua").tabs()<CR>', opts)
remap('n', '<C-f>h', '<cmd>lua require("fzf-lua").oldfiles()<CR>', opts)
remap('n', '<C-f>r', '<cmd>lua require("fzf-lua").registers()<CR>', opts)

remap('i', '<C-f>f', '<cmd>lua require("fzf-lua").files()<CR>', opts)
remap('i', "<C-f>'", '<cmd>lua require("fzf-lua").buffers()<CR>', opts)
remap('i', '<C-f>g', '<cmd>lua require("fzf-lua").live_grep()<CR>', opts)
remap('i', '<C-f>gg', '<cmd>lua require("fzf-lua").live_grep_resume()<CR>', opts)
remap('i', '<C-f>G', '<cmd>lua require("fzf-lua").grep()<CR>', opts)
remap('i', '<C-f>GG', '<cmd>lua require("fzf-lua").grep_resume()<CR>', opts)
remap('i', '<C-f>m', '<cmd>lua require("fzf-lua").marks()<CR>', opts)
remap('i', '<C-f>t', '<cmd>lua require("fzf-lua").tabs()<CR>', opts)
remap('i', '<C-f>h', '<cmd>lua require("fzf-lua").oldfiles()<CR>', opts)
remap('i', '<C-f>r', '<cmd>lua require("fzf-lua").registers()<CR>', opts)

-- lsp
remap('n', 'gD', '<Cmd>lua require("fzf-lua").lsp_declarations()<CR>', opts)
remap('n', 'gd', '<Cmd>lua require("fzf-lua").lsp_definitions()<CR>', opts)
remap('n', 'gdd', '<Cmd>lua require("fzf-lua").lsp_typedefs()<CR>', opts)
remap('n', 'gi', '<cmd>lua require("fzf-lua").lsp_implementations()<CR>', opts)
remap('n', '<leader>a', '<cmd>lua require("fzf-lua").lsp_code_actions()<CR>', opts)
remap('n', '<leader>u', '<cmd>lua require("fzf-lua").lsp_references()<CR>', opts)
remap('n', '<space>e', '<cmd>lua require("fzf-lua").lsp_document_diagnostics()<CR>', opts)
remap('n', '<space>ee', '<cmd>lua require("fzf-lua").lsp_workspace_diagnostics()<CR>', opts)
remap('n', '<space>SS', '<cmd>lua require("fzf-lua").lsp_live_workspace_symbols()<CR>', opts)
remap('n', '<space>S', '<cmd>lua require("fzf-lua").lsp_document_symbols()<CR>', opts)
-- c-l (lsp) namespaced
remap('n', '<C-l>D', '<Cmd>lua require("fzf-lua").lsp_declarations()<CR>', opts)
remap('n', '<C-l>d', '<Cmd>lua require("fzf-lua").lsp_definitions()<CR>', opts)
remap('n', '<C-l>dd', '<Cmd>lua require("fzf-lua").lsp_typedefs()<CR>', opts)
remap('n', '<C-l>ii', '<cmd>lua require("fzf-lua").lsp_implementations()<CR>', opts)
remap('n', '<C-l>a', '<cmd>lua require("fzf-lua").lsp_code_actions()<CR>', opts)
remap('n', '<C-l>u', '<cmd>lua require("fzf-lua").lsp_references()<CR>', opts)
remap('n', '<C-l>e', '<cmd>lua require("fzf-lua").lsp_document_diagnostics()<CR>', opts)
remap('n', '<C-l>ee', '<cmd>lua require("fzf-lua").lsp_workspace_diagnostics()<CR>', opts)
remap('n', '<C-l>SS', '<cmd>lua require("fzf-lua").lsp_live_workspace_symbols()<CR>', opts)
remap('n', '<C-l>S', '<cmd>lua require("fzf-lua").lsp_document_symbols()<CR>', opts)

remap('i', '<C-l>D', '<Cmd>lua require("fzf-lua").lsp_declarations()<CR>', opts)
remap('i', '<C-l>d', '<Cmd>lua require("fzf-lua").lsp_definitions()<CR>', opts)
remap('i', '<C-l>dd', '<Cmd>lua require("fzf-lua").lsp_typedefs()<CR>', opts)
remap('i', '<C-l>ii', '<cmd>lua require("fzf-lua").lsp_implementations()<CR>', opts)
remap('i', '<C-l>a', '<cmd>lua require("fzf-lua").lsp_code_actions()<CR>', opts)
remap('i', '<C-l>u', '<cmd>lua require("fzf-lua").lsp_references()<CR>', opts)
remap('i', '<C-l>e', '<cmd>lua require("fzf-lua").lsp_document_diagnostics()<CR>', opts)
remap('i', '<C-l>ee', '<cmd>lua require("fzf-lua").lsp_workspace_diagnostics()<CR>', opts)
remap('i', '<C-l>s', '<cmd>lua require("fzf-lua").lsp_live_workspace_symbols()<CR>', opts)
remap('i', '<C-l>ss', '<cmd>lua require("fzf-lua").lsp_document_symbols()<CR>', opts)
-- c-g (git) namespaced
remap('n', '<C-g>ss', '<cmd>lua require("fzf-lua").git_status()<CR>', opts)
remap('n', '<C-g>b', '<cmd>lua require("fzf-lua").git_branches()<CR>', opts)
remap('n', '<C-g>c', '<cmd>lua require("fzf-lua").git_bcommits()<CR>', opts)
remap('n', '<C-g>C', '<cmd>lua require("fzf-lua").git_commits()<CR>', opts)

remap('i', '<C-g>ss', '<cmd>lua require("fzf-lua").git_status()<CR>', opts)
remap('i', '<C-g>b', '<cmd>lua require("fzf-lua").git_branches()<CR>', opts)
remap('i', '<C-g>c', '<cmd>lua require("fzf-lua").git_bcommits()<CR>', opts)
remap('i', '<C-g>C', '<cmd>lua require("fzf-lua").git_commits()<CR>', opts)

local actions = require "fzf-lua.actions"
require'fzf-lua'.setup {
  winopts = {
    -- split         = "new",           -- open in a split instead?
    win_height       = 0.80,            -- window height
    win_width        = 0.80,            -- window width
    win_row          = 0.30,            -- window row position (0=top, 1=bottom)
    win_col          = 0.50,            -- window col position (0=left, 1=right)
    -- win_border    = false,           -- window border? or borderchars?
    win_border       = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    hl_normal        = 'Normal',        -- window normal color
    hl_border        = 'FloatBorder',   -- window border color
  },
  keymap = {
      builtin = {
        -- neovim `:tmap` mappings for the fzf win
        ["<F2>"]        = "toggle-fullscreen",
        -- Only valid with the 'builtin' previewer
        ["<F3>"]        = "toggle-preview-wrap",
        ["<F4>"]        = "toggle-preview",
        -- Rotate preview clockwise/counter-clockwise
        ["<F5>"]        = "toggle-preview-ccw",
        ["<F6>"]        = "toggle-preview-cw",
        ["<C-n>"]       = "preview-page-down",
        ["<C-p>"]       = "preview-page-up",
        ["<S-left>"]    = "preview-page-reset",
      },
      fzf = {               -- fzf '--bind=' options
        ["ctrl-P"]          = "toggle-preview",
        ["f3"]              = "toggle-preview-wrap",
        ["ctrl-D"]          = "preview-page-down",
        ["ctrl-U"]          = "preview-page-up",
        ["ctrl-u"]          = "unix-line-discard",
        ["ctrl-f"]          = "half-page-down",
        ["ctrl-b"]          = "half-page-up",
        ["ctrl-a"]          = "beginning-of-line",
        ["ctrl-e"]          = "end-of-line",
        ["ctrl-A"]          = "toggle-all",
      },
  },
  -- fzf_bin             = 'sk',        -- use skim instead of fzf?
  fzf_opts = {
    -- options are sent as `<left>=<right>`
    -- set to `false` to remove a flag
    -- set to '' for a non-value flag
    -- for raw args use `fzf_args` instead
    ['--ansi']        = '',
    ['--prompt']      = ' >',
    ['--info']        = 'inline',
    ['--height']      = '100%',
    ['--layout']      = 'reverse',
  },
  fzf_args            = vim.env.FZF_DEFAULT_OPTS, -- adv: fzf extra args, empty unless adv
  preview_border      = 'border',       -- border|noborder
  preview_wrap        = 'nowrap',       -- wrap|nowrap
  preview_vertical    = 'down:50%',     -- up|down:size
  preview_horizontal  = 'right:60%',    -- right|left:size
  preview_layout      = 'vertical',         -- horizontal|vertical|flex
  flip_columns        = 120,            -- #cols to switch to horizontal on flex
  default_previewer   = "builtin",          -- override the default previewer?
                                        -- by default auto-detect bat|cat
  previewers = {
    bat = {
      cmd             = "bat",
      args            = "--style=numbers,changes --color always",
      theme           = vim.env.BAT_THEME, -- bat preview theme (bat --list-themes)
      config          = nil,               -- nil uses $BAT_CONFIG_PATH
    },
    builtin = {
      title           = true,         -- preview title?
      scrollbar       = true,         -- scrollbar?
      scrollchar      = '█',          -- scrollbar character
      syntax          = true,         -- preview syntax highlight?
      syntax_limit_l  = 0,            -- syntax limit (lines), 0=nolimit
      syntax_limit_b  = 1024*1024,    -- syntax limit (bytes), 0=nolimit
      expand          = false,        -- preview max size?
      hl_cursor       = 'Cursor',     -- cursor highlight
      hl_cursorline   = 'Visual', -- cursor line highlight
      hl_range        = 'IncSearch',  -- ranger highlight (not yet in use)
    },
  },
  -- provider setup
  files = {
    prompt            = 'Files❯ ',
    cmd               = '',             -- "find . -type f -printf '%P\n'",
    git_icons         = false,           -- show git icons?
    file_icons        = false,           -- show file icons?
    color_icons       = true,           -- colorize file|git icons
    actions = {
      ["default"]     = actions.file_edit,
      ["ctrl-S"]      = actions.file_split,
      ["ctrl-V"]      = actions.file_vsplit,
      ["ctrl-T"]      = actions.file_tabedit,
      ["ctrl-Q"]      = actions.file_sel_to_qf,
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
    },
    fd_opts           = [[ --no-ignore-vcs --color never --type f --hidden --follow ]] ..
                    [[--exclude .git --exclude node_modules --exclude '*.pyc']],
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
    color_icons       = true,           -- colorize file|git icons
    actions = {
      ["default"]    = actions.file_edit,
      ["ctrl-S"]      = actions.file_split,
      ["ctrl-V"]      = actions.file_vsplit,
      ["ctrl-T"]      = actions.file_tabedit,
      ["ctrl-Q"]      = actions.file_sel_to_qf,
      ["ctrl-y"]     = function(selected) print(selected[2]) end,
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
      ["default"]    = actions.buf_edit,
      ["ctrl-S"]      = actions.buf_split,
      ["ctrl-V"]      = actions.buf_vsplit,
      ["ctrl-T"]      = actions.buf_tabedit,
      ["ctrl-D"]      = actions.buf_del,
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
    actions = {
      ["default"]           = actions.file_edit,
      ["ctrl-S"]      = actions.file_split,
      ["ctrl-V"]      = actions.file_vsplit,
      ["ctrl-T"]      = actions.file_tabedit,
      ["ctrl-Q"]      = actions.file_sel_to_qf,
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
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


