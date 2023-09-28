--[[
Reference for unicode value:
  https://github.com/microsoft/vscode-codicons/blob/main/src/template/mapping.json
--]]

---@class codiconConfigNamed
---@field icon string
---@field name string | string[]

---@class codiconConfigNumbered
---@field icon string
---@field unicode integer

---@alias codiconConfigIdentifier string | integer
---@alias codiconConfig codiconConfigNamed | codiconConfigNumbered

---@alias codiconConfigTable table<codiconConfigIdentifier, codiconConfig>

---@type codiconConfigTable
local codicons = {
  ['account']                                 = { icon = '', unicode = 0xEB99 },
  ['activate-breakpoints']                    = { icon = '', unicode = 0xEA97 },
  ['add']                                     = { icon = '', unicode = 0xEA60 },
  ['alert']                                   = { icon = '', unicode = 0xEA6C },
  ['archive']                                 = { icon = '', unicode = 0xEA98 },
  ['array']                                   = { icon = '', unicode = 0xEA8A },
  ['arrow-both']                              = { icon = '', unicode = 0xEA99 },
  ['arrow-down']                              = { icon = '', unicode = 0xEA9A },
  ['arrow-left']                              = { icon = '', unicode = 0xEA9B },
  ['arrow-right']                             = { icon = '', unicode = 0xEA9C },
  ['arrow-small-down']                        = { icon = '', unicode = 0xEA9D },
  ['arrow-small-left']                        = { icon = '', unicode = 0xEA9E },
  ['arrow-small-right']                       = { icon = '', unicode = 0xEA9F },
  ['arrow-small-up']                          = { icon = '', unicode = 0xEAA0 },
  ['arrow-swap']                              = { icon = '', unicode = 0xEBCB },
  ['arrow-up']                                = { icon = '', unicode = 0xEAA1 },
  ['beaker']                                  = { icon = '', unicode = 0xEA79 },
  ['bell']                                    = { icon = '', unicode = 0xEAA2 },
  ['bell-dot']                                = { icon = '', unicode = 0xEB9A },
  ['bold']                                    = { icon = '', unicode = 0xEAA3 },
  ['book']                                    = { icon = '', unicode = 0xEAA4 },
  ['bookmark']                                = { icon = '', unicode = 0xEAA5 },
  ['briefcase']                               = { icon = '', unicode = 0xEAAC },
  ['broadcast']                               = { icon = '', unicode = 0xEAAD },
  ['browser']                                 = { icon = '', unicode = 0xEAAE },
  ['bug']                                     = { icon = '', unicode = 0xEAAF },
  ['calendar']                                = { icon = '', unicode = 0xEAB0 },
  ['call-incoming']                           = { icon = '', unicode = 0xEB92 },
  ['call-outgoing']                           = { icon = '', unicode = 0xEB93 },
  ['case-sensitive']                          = { icon = '', unicode = 0xEAB1 },
  ['check']                                   = { icon = '', unicode = 0xEAB2 },
  ['check-all']                               = { icon = '', unicode = 0xEBB1 },
  ['checklist']                               = { icon = '', unicode = 0xEAB3 },
  ['chevron-down']                            = { icon = '', unicode = 0xEAB4 },
  ['chevron-left']                            = { icon = '', unicode = 0xEAB5 },
  ['chevron-right']                           = { icon = '', unicode = 0xEAB6 },
  ['chevron-up']                              = { icon = '', unicode = 0xEAB7 },
  ['chrome-close']                            = { icon = '', unicode = 0xEAB8 },
  ['chrome-maximize']                         = { icon = '', unicode = 0xEAB9 },
  ['chrome-minimize']                         = { icon = '', unicode = 0xEABA },
  ['chrome-restore']                          = { icon = '', unicode = 0xEABB },
  ['circle-filled']                           = { icon = '', unicode = 0xEA71 },
  ['circle-large-filled']                     = { icon = '', unicode = 0xEBB4 },
  ['circle-large-outline']                    = { icon = '', unicode = 0xEBB5 },
  ['circle-outline']                          = { icon = '', unicode = 0xEABC },
  ['circle-slash']                            = { icon = '', unicode = 0xEABD },
  ['circuit-board']                           = { icon = '', unicode = 0xEABE },
  ['clear-all']                               = { icon = '', unicode = 0xEABF },
  ['clippy']                                  = { icon = '', unicode = 0xEAC0 },
  ['clock']                                   = { icon = '', unicode = 0xEA82 },
  ['clone']                                   = { icon = '', unicode = 0xEA78 },
  ['close']                                   = { icon = '', unicode = 0xEA76 },
  ['close-all']                               = { icon = '', unicode = 0xEAC1 },
  ['close-dirty']                             = { icon = '', unicode = 0xEA71 },
  ['cloud']                                   = { icon = '', unicode = 0xEBAA },
  ['cloud-download']                          = { icon = '', unicode = 0xEAC2 },
  ['cloud-upload']                            = { icon = '', unicode = 0xEAC3 },
  ['code']                                    = { icon = '', unicode = 0xEAC4 },
  ['collapse-all']                            = { icon = '', unicode = 0xEAC5 },
  ['color-mode']                              = { icon = '', unicode = 0xEAC6 },
  ['combine']                                 = { icon = '', unicode = 0xEBB6 },
  ['comment']                                 = { icon = '', unicode = 0xEA6B },
  ['comment-add']                             = { icon = '', unicode = 0xEA6B },
  ['comment-discussion']                      = { icon = '', unicode = 0xEAC7 },
  ['compare-changes']                         = { icon = '', unicode = 0xEAFD },
  ['console']                                 = { icon = '', unicode = 0xEA85 },
  ['copy']                                    = { icon = '', unicode = 0xEBCC },
  ['credit-card']                             = { icon = '', unicode = 0xEAC9 },
  ['dash']                                    = { icon = '', unicode = 0xEACC },
  ['dashboard']                               = { icon = '', unicode = 0xEACD },
  ['database']                                = { icon = '', unicode = 0xEACE },
  ['debug']                                   = { icon = '', unicode = 0xEAD8 },
  ['debug-alt']                               = { icon = '', unicode = 0xEB91 },
  ['debug-alt-small']                         = { icon = '', unicode = 0xEBA8 },
  ['debug-breakpoint']                        = { icon = '', unicode = 0xEA71 },
  ['debug-breakpoint-conditional']            = { icon = '', unicode = 0xEAA7 },
  ['debug-breakpoint-conditional-disabled']   = { icon = '', unicode = 0xEAA7 },
  ['debug-breakpoint-conditional-unverified'] = { icon = '', unicode = 0xEAA6 },
  ['debug-breakpoint-data']                   = { icon = '', unicode = 0xEAA9 },
  ['debug-breakpoint-data-disabled']          = { icon = '', unicode = 0xEAA9 },
  ['debug-breakpoint-data-unverified']        = { icon = '', unicode = 0xEAA8 },
  ['debug-breakpoint-disabled']               = { icon = '', unicode = 0xEA71 },
  ['debug-breakpoint-function']               = { icon = '', unicode = 0xEB88 },
  ['debug-breakpoint-function-disabled']      = { icon = '', unicode = 0xEB88 },
  ['debug-breakpoint-function-unverified']    = { icon = '', unicode = 0xEB87 },
  ['debug-breakpoint-log']                    = { icon = '', unicode = 0xEAAB },
  ['debug-breakpoint-log-disabled']           = { icon = '', unicode = 0xEAAB },
  ['debug-breakpoint-log-unverified']         = { icon = '', unicode = 0xEAAA },
  ['debug-breakpoint-unsupported']            = { icon = '', unicode = 0xEB8C },
  ['debug-breakpoint-unverified']             = { icon = '', unicode = 0xEABC },
  ['debug-console']                           = { icon = '', unicode = 0xEB9B },
  ['debug-continue']                          = { icon = '', unicode = 0xEACF },
  ['debug-disconnect']                        = { icon = '', unicode = 0xEAD0 },
  ['debug-line-by-line']                      = { icon = '', unicode = 0xEBD0 },
  ['debug-hint']                              = { icon = '', unicode = 0xEA71 },
  ['debug-pause']                             = { icon = '', unicode = 0xEAD1 },
  ['debug-rerun']                             = { icon = '', unicode = 0xEBC0 },
  ['debug-restart']                           = { icon = '', unicode = 0xEAD2 },
  ['debug-restart-frame']                     = { icon = '', unicode = 0xEB90 },
  ['debug-reverse-continue']                  = { icon = '', unicode = 0xEB8E },
  ['debug-stackframe']                        = { icon = '', unicode = 0xEB8B },
  ['debug-stackframe-active']                 = { icon = '', unicode = 0xEB89 },
  ['debug-stackframe-dot']                    = { icon = '', unicode = 0xEB8A },
  ['debug-stackframe-focused']                = { icon = '', unicode = 0xEB8B },
  ['debug-start']                             = { icon = '', unicode = 0xEAD3 },
  ['debug-step-back']                         = { icon = '', unicode = 0xEB8F },
  ['debug-step-into']                         = { icon = '', unicode = 0xEAD4 },
  ['debug-step-out']                          = { icon = '', unicode = 0xEAD5 },
  ['debug-step-over']                         = { icon = '', unicode = 0xEAD6 },
  ['debug-stop']                              = { icon = '', unicode = 0xEAD7 },
  ['desktop-download']                        = { icon = '', unicode = 0xEA78 },
  ['device-camera']                           = { icon = '', unicode = 0xEADA },
  ['device-camera-video']                     = { icon = '', unicode = 0xEAD9 },
  ['device-desktop']                          = { icon = '', unicode = 0xEA7A },
  ['device-mobile']                           = { icon = '', unicode = 0xEADB },
  ['diff']                                    = { icon = '', unicode = 0xEAE1 },
  ['diff-added']                              = { icon = '', unicode = 0xEADC },
  ['diff-ignored']                            = { icon = '', unicode = 0xEADD },
  ['diff-modified']                           = { icon = '', unicode = 0xEADE },
  ['diff-removed']                            = { icon = '', unicode = 0xEADF },
  ['diff-renamed']                            = { icon = '', unicode = 0xEAE0 },
  ['discard']                                 = { icon = '', unicode = 0xEAE2 },
  -- drop-down-button
  ['edit']                                    = { icon = '', unicode = 0xEA73 },
  ['editor-layout']                           = { icon = '', unicode = 0xEAE3 },
  ['ellipsis']                                = { icon = '', unicode = 0xEA7C },
  ['empty-window']                            = { icon = '', unicode = 0xEAE4 },
  ['error']                                   = { icon = '', unicode = 0xEA87 },
  ['exclude']                                 = { icon = '', unicode = 0xEAE5 },
  ['expand-all']                              = { icon = '', unicode = 0xEB95 },
  ['export']                                  = { icon = '', unicode = 0xEBAC },
  ['extensions']                              = { icon = '', unicode = 0xEAE6 },
  ['eye']                                     = { icon = '', unicode = 0xEA70 },
  ['eye-closed']                              = { icon = '', unicode = 0xEAE7 },
  ['eye-unwatch']                             = { icon = '', unicode = 0xEA70 },
  ['eye-watch']                               = { icon = '', unicode = 0xEA70 },
  ['feedback']                                = { icon = '', unicode = 0xEB96 },
  ['file']                                    = { icon = '', unicode = 0xEA7B },
  ['file-add']                                = { icon = '', unicode = 0xEA7F },
  ['file-binary']                             = { icon = '', unicode = 0xEAE8 },
  ['file-code']                               = { icon = '', unicode = 0xEAE9 },
  ['file-directory']                          = { icon = '', unicode = 0xEA83 },
  ['file-directory-create']                   = { icon = '', unicode = 0xEA80 },
  ['file-media']                              = { icon = '', unicode = 0xEAEA },
  ['file-pdf']                                = { icon = '', unicode = 0xEAEB },
  ['file-submodule']                          = { icon = '', unicode = 0xEAEC },
  ['file-symlink-directory']                  = { icon = '', unicode = 0xEAED },
  ['file-symlink-file']                       = { icon = '', unicode = 0xEAEE },
  ['file-text']                               = { icon = '', unicode = 0xEA7B },
  ['file-zip']                                = { icon = '', unicode = 0xEAEF },
  ['files']                                   = { icon = '', unicode = 0xEAF0 },
  ['filter']                                  = { icon = '', unicode = 0xEAF1 },
  ['filter-filled']                           = { icon = '', unicode = 0xEBCE },
  ['flame']                                   = { icon = '', unicode = 0xEAF2 },
  ['fold']                                    = { icon = '', unicode = 0xEAF5 },
  ['fold-down']                               = { icon = '', unicode = 0xEAF3 },
  ['fold-up']                                 = { icon = '', unicode = 0xEAF4 },
  ['folder']                                  = { icon = '', unicode = 0xEA83 },
  ['folder-active']                           = { icon = '', unicode = 0xEAF6 },
  ['folder-opened']                           = { icon = '', unicode = 0xEAF7 },
  ['gather']                                  = { icon = '', unicode = 0xEBB6 },
  ['gear']                                    = { icon = '', unicode = 0xEAF8 },
  ['gift']                                    = { icon = '', unicode = 0xEAF9 },
  ['gist']                                    = { icon = '', unicode = 0xEAFB },
  ['gist-fork']                               = { icon = '', unicode = 0xEA63 },
  ['gist-new']                                = { icon = '', unicode = 0xEA60 },
  ['gist-private']                            = { icon = '', unicode = 0xEA75 },
  ['gist-secret']                             = { icon = '', unicode = 0xEAFA },
  ['git-branch']                              = { icon = '', unicode = 0xEA68 },
  ['git-branch-create']                       = { icon = '', unicode = 0xEA68 },
  ['git-branch-delete']                       = { icon = '', unicode = 0xEA68 },
  ['git-commit']                              = { icon = '', unicode = 0xEAFC },
  ['git-compare']                             = { icon = '', unicode = 0xEAFD },
  ['git-fork-private']                        = { icon = '', unicode = 0xEA75 },
  ['git-merge']                               = { icon = '', unicode = 0xEAFE },
  ['git-pull-request']                        = { icon = '', unicode = 0xEA64 },
  ['git-pull-request-abandoned']              = { icon = '', unicode = 0xEA64 },
  ['git-pull-request-create']                 = { icon = '', unicode = 0xEBBC },
  ['github']                                  = { icon = '', unicode = 0xEA84 },
  ['github-action']                           = { icon = '', unicode = 0xEAFF },
  ['github-alt']                              = { icon = '', unicode = 0xEB00 },
  ['github-inverted']                         = { icon = '', unicode = 0xEBA1 },
  ['globe']                                   = { icon = '', unicode = 0xEB01 },
  ['go-to-file']                              = { icon = '', unicode = 0xEA94 },
  ['grabber']                                 = { icon = '', unicode = 0xEB02 },
  ['graph']                                   = { icon = '', unicode = 0xEB03 },
  ['graph-left']                              = { icon = '', unicode = 0xEBAD },
  ['gripper']                                 = { icon = '', unicode = 0xEB04 },
  ['group-by-ref-type']                       = { icon = '', unicode = 0xEB97 },
  ['heart']                                   = { icon = '', unicode = 0xEB05 },
  ['history']                                 = { icon = '', unicode = 0xEA82 },
  ['home']                                    = { icon = '', unicode = 0xEB06 },
  ['horizontal-rule']                         = { icon = '', unicode = 0xEB07 },
  ['hubot']                                   = { icon = '', unicode = 0xEB08 },
  ['inbox']                                   = { icon = '', unicode = 0xEB09 },
  ['info']                                    = { icon = '', unicode = 0xEA74 },
  ['inspect']                                 = { icon = '', unicode = 0xEBD1 },
  ['issue-closed']                            = { icon = '', unicode = 0xEB0A },
  ['issue-opened']                            = { icon = '', unicode = 0xEA74 },
  ['issue-reopened']                          = { icon = '', unicode = 0xEB0B },
  ['issues']                                  = { icon = '', unicode = 0xEB0C },
  ['italic']                                  = { icon = '', unicode = 0xEB0D },
  ['jersey']                                  = { icon = '', unicode = 0xEB0E },
  ['json']                                    = { icon = '', unicode = 0xEB0F },
  ['kebab-horizontal']                        = { icon = '', unicode = 0xEA7C },
  ['kebab-vertical']                          = { icon = '', unicode = 0xEB10 },
  ['key']                                     = { icon = '', unicode = 0xEB11 },
  ['keyboard']                                = { icon = '', unicode = 0xEA65 },
  ['law']                                     = { icon = '', unicode = 0xEB12 },
  ['library']                                 = { icon = '', unicode = 0xEB9C },
  ['light-bulb']                              = { icon = '', unicode = 0xEA61 },
  ['lightbulb']                               = { icon = '', unicode = 0xEA61 },
  ['lightbulb-autofix']                       = { icon = '', unicode = 0xEB13 },
  ['link']                                    = { icon = '', unicode = 0xEB15 },
  ['link-external']                           = { icon = '', unicode = 0xEB14 },
  ['list-filter']                             = { icon = '', unicode = 0xEB83 },
  ['list-flat']                               = { icon = '', unicode = 0xEB84 },
  ['list-ordered']                            = { icon = '', unicode = 0xEB16 },
  ['list-selection']                          = { icon = '', unicode = 0xEB85 },
  ['list-tree']                               = { icon = '', unicode = 0xEB86 },
  ['list-unordered']                          = { icon = '', unicode = 0xEB17 },
  ['live-share']                              = { icon = '', unicode = 0xEB18 },
  ['loading']                                 = { icon = '', unicode = 0xEB19 },
  ['location']                                = { icon = '', unicode = 0xEB1A },
  ['lock']                                    = { icon = '', unicode = 0xEA75 },
  ['log-in']                                  = { icon = '', unicode = 0xEA6F },
  ['log-out']                                 = { icon = '', unicode = 0xEA6E },
  ['logo-github']                             = { icon = '', unicode = 0xEA84 },
  ['magnet']                                  = { icon = '', unicode = 0xEBAE },
  ['mail']                                    = { icon = '', unicode = 0xEB1C },
  ['mail-read']                               = { icon = '', unicode = 0xEB1B },
  ['mail-reply']                              = { icon = '', unicode = 0xEA7D },
  ['markdown']                                = { icon = '', unicode = 0xEB1D },
  ['megaphone']                               = { icon = '', unicode = 0xEB1E },
  ['mention']                                 = { icon = '', unicode = 0xEB1F },
  ['menu']                                    = { icon = '', unicode = 0xEB94 },
  ['merge']                                   = { icon = '', unicode = 0xEBAB },
  ['microscope']                              = { icon = '', unicode = 0xEA79 },
  ['milestone']                               = { icon = '', unicode = 0xEB20 },
  ['mirror']                                  = { icon = '', unicode = 0xEA69 },
  ['mirror-private']                          = { icon = '', unicode = 0xEA75 },
  ['mirror-public']                           = { icon = '', unicode = 0xEA69 },
  ['more']                                    = { icon = '', unicode = 0xEA7C },
  ['mortar-board']                            = { icon = '', unicode = 0xEB21 },
  ['move']                                    = { icon = '', unicode = 0xEB22 },
  ['multiple-windows']                        = { icon = '', unicode = 0xEB23 },
  ['mute']                                    = { icon = '', unicode = 0xEB24 },
  ['new-file']                                = { icon = '', unicode = 0xEA7F },
  ['new-folder']                              = { icon = '', unicode = 0xEA80 },
  ['no-newline']                              = { icon = '', unicode = 0xEB25 },
  ['note']                                    = { icon = '', unicode = 0xEB26 },
  ['notebook']                                = { icon = '', unicode = 0xEBAF },
  ['notebook-template']                       = { icon = '', unicode = 0xEBBF },
  ['octoface']                                = { icon = '', unicode = 0xEB27 },
  ['open-preview']                            = { icon = '', unicode = 0xEB28 },
  ['organization']                            = { icon = '', unicode = 0xEA7E },
  ['organization-filled']                     = { icon = '', unicode = 0xEA7E },
  ['organization-outline']                    = { icon = '', unicode = 0xEA7E },
  ['output']                                  = { icon = '', unicode = 0xEB9D },
  ['package']                                 = { icon = '', unicode = 0xEB29 },
  ['paintcan']                                = { icon = '', unicode = 0xEB2A },
  ['pass']                                    = { icon = '', unicode = 0xEBA4 },
  ['pass-filled']                             = { icon = '', unicode = 0xEBB3 },
  ['pencil']                                  = { icon = '', unicode = 0xEA73 },
  ['person']                                  = { icon = '', unicode = 0xEA67 },
  ['person-add']                              = { icon = '', unicode = 0xEBCD },
  ['person-filled']                           = { icon = '', unicode = 0xEA67 },
  ['person-follow']                           = { icon = '', unicode = 0xEA67 },
  ['person-outline']                          = { icon = '', unicode = 0xEA67 },
  ['pin']                                     = { icon = '', unicode = 0xEB2B },
  ['pinned']                                  = { icon = '', unicode = 0xEBA0 },
  ['pinned-dirty']                            = { icon = '', unicode = 0xEBB2 },
  ['play']                                    = { icon = '', unicode = 0xEB2C },
  ['play-circle']                             = { icon = '', unicode = 0xEBA6 },
  ['plug']                                    = { icon = '', unicode = 0xEB2D },
  ['plus']                                    = { icon = '', unicode = 0xEA60 },
  ['preserve-case']                           = { icon = '', unicode = 0xEB2E },
  ['preview']                                 = { icon = '', unicode = 0xEB2F },
  ['primitive-dot']                           = { icon = '', unicode = 0xEA71 },
  ['primitive-square']                        = { icon = '', unicode = 0xEA72 },
  ['project']                                 = { icon = '', unicode = 0xEB30 },
  ['pulse']                                   = { icon = '', unicode = 0xEB31 },
  ['question']                                = { icon = '', unicode = 0xEB32 },
  ['quote']                                   = { icon = '', unicode = 0xEB33 },
  ['radio-tower']                             = { icon = '', unicode = 0xEB34 },
  ['reactions']                               = { icon = '', unicode = 0xEB35 },
  ['record']                                  = { icon = '', unicode = 0xEBA7 },
  ['record-keys']                             = { icon = '', unicode = 0xEA65 },
  ['redo']                                    = { icon = '', unicode = 0xEBB0 },
  ['references']                              = { icon = '', unicode = 0xEB36 },
  ['refresh']                                 = { icon = '', unicode = 0xEB37 },
  ['regex']                                   = { icon = '', unicode = 0xEB38 },
  ['remote']                                  = { icon = '', unicode = 0xEB3A },
  ['remote-explorer']                         = { icon = '', unicode = 0xEB39 },
  ['remove']                                  = { icon = '', unicode = 0xEB3B },
  ['remove-close']                            = { icon = '', unicode = 0xEA76 },
  ['repl']                                    = { icon = '', unicode = 0xEA85 },
  ['replace']                                 = { icon = '', unicode = 0xEB3D },
  ['replace-all']                             = { icon = '', unicode = 0xEB3C },
  ['reply']                                   = { icon = '', unicode = 0xEA7D },
  ['repo']                                    = { icon = '', unicode = 0xEA62 },
  ['repo-clone']                              = { icon = '', unicode = 0xEB3E },
  ['repo-create']                             = { icon = '', unicode = 0xEA60 },
  ['repo-delete']                             = { icon = '', unicode = 0xEA62 },
  ['repo-force-push']                         = { icon = '', unicode = 0xEB3F },
  ['repo-forked']                             = { icon = '', unicode = 0xEA63 },
  ['repo-pull']                               = { icon = '', unicode = 0xEB40 },
  ['repo-push']                               = { icon = '', unicode = 0xEB41 },
  ['repo-sync']                               = { icon = '', unicode = 0xEA77 },
  ['report']                                  = { icon = '', unicode = 0xEB42 },
  ['request-changes']                         = { icon = '', unicode = 0xEB43 },
  ['rocket']                                  = { icon = '', unicode = 0xEB44 },
  ['root-folder']                             = { icon = '', unicode = 0xEB46 },
  ['root-folder-opened']                      = { icon = '', unicode = 0xEB45 },
  ['rss']                                     = { icon = '', unicode = 0xEB47 },
  ['ruby']                                    = { icon = '', unicode = 0xEB48 },
  ['run']                                     = { icon = '', unicode = 0xEB2C },
  ['run-all']                                 = { icon = '', unicode = 0xEB9E },
  ['run-above']                               = { icon = '', unicode = 0xEBBD },
  ['run-below']                               = { icon = '', unicode = 0xEBBE },
  ['save']                                    = { icon = '', unicode = 0xEB4B },
  ['save-all']                                = { icon = '', unicode = 0xEB49 },
  ['save-as']                                 = { icon = '', unicode = 0xEB4A },
  ['screen-full']                             = { icon = '', unicode = 0xEB4C },
  ['screen-normal']                           = { icon = '', unicode = 0xEB4D },
  ['search']                                  = { icon = '', unicode = 0xEA6D },
  ['search-save']                             = { icon = '', unicode = 0xEA6D },
  ['search-stop']                             = { icon = '', unicode = 0xEB4E },
  ['selection']                               = { icon = '', unicode = 0xEB85 },
  ['server']                                  = { icon = '', unicode = 0xEB50 },
  ['server-environment']                      = { icon = '', unicode = 0xEBA3 },
  ['server-process']                          = { icon = '', unicode = 0xEBA2 },
  ['settings']                                = { icon = '', unicode = 0xEB52 },
  ['settings-gear']                           = { icon = '', unicode = 0xEB51 },
  ['shield']                                  = { icon = '', unicode = 0xEB53 },
  ['sign-in']                                 = { icon = '', unicode = 0xEA6F },
  ['sign-out']                                = { icon = '', unicode = 0xEA6E },
  ['smiley']                                  = { icon = '', unicode = 0xEB54 },
  ['sort-precedence']                         = { icon = '', unicode = 0xEB55 },
  ['source-control']                          = { icon = '', unicode = 0xEA68 },
  ['split-horizontal']                        = { icon = '', unicode = 0xEB56 },
  ['split-vertical']                          = { icon = '', unicode = 0xEB57 },
  ['squirrel']                                = { icon = '', unicode = 0xEB58 },
  ['star']                                    = { icon = '', unicode = 0xEA6A },
  ['star-add']                                = { icon = '', unicode = 0xEA6A },
  ['star-delete']                             = { icon = '', unicode = 0xEA6A },
  ['star-empty']                              = { icon = '', unicode = 0xEA6A },
  ['star-full']                               = { icon = '', unicode = 0xEB59 },
  ['star-half']                               = { icon = '', unicode = 0xEB5A },
  ['stop']                                    = { icon = '', unicode = 0xEA87 },
  ['stop-circle']                             = { icon = '', unicode = 0xEBA5 },
  ['symbol-array']                            = { icon = '', unicode = 0xEA8A },
  ['symbol-boolean']                          = { icon = '', unicode = 0xEA8F },
  ['symbol-class']                            = { icon = '', unicode = 0xEB5B },
  ['symbol-color']                            = { icon = '', unicode = 0xEB5C },
  ['symbol-constant']                         = { icon = '', unicode = 0xEB5D },
  ['symbol-constructor']                      = { icon = '', unicode = 0xEA8C },
  ['symbol-enum']                             = { icon = '', unicode = 0xEA95 },
  ['symbol-enum-member']                      = { icon = '', unicode = 0xEB5E },
  ['symbol-event']                            = { icon = '', unicode = 0xEA86 },
  ['symbol-field']                            = { icon = '', unicode = 0xEB5F },
  ['symbol-file']                             = { icon = '', unicode = 0xEB60 },
  ['symbol-folder']                           = { icon = '', unicode = 0xEA83 },
  ['symbol-function']                         = { icon = '', unicode = 0xEA8C },
  ['symbol-interface']                        = { icon = '', unicode = 0xEB61 },
  ['symbol-key']                              = { icon = '', unicode = 0xEA93 },
  ['symbol-keyword']                          = { icon = '', unicode = 0xEB62 },
  ['symbol-method']                           = { icon = '', unicode = 0xEA8C },
  ['symbol-misc']                             = { icon = '', unicode = 0xEB63 },
  ['symbol-module']                           = { icon = '', unicode = 0xEA8B },
  ['symbol-namespace']                        = { icon = '', unicode = 0xEA8B },
  ['symbol-null']                             = { icon = '', unicode = 0xEA8F },
  ['symbol-number']                           = { icon = '', unicode = 0xEA90 },
  ['symbol-numeric']                          = { icon = '', unicode = 0xEA90 },
  ['symbol-object']                           = { icon = '', unicode = 0xEA8B },
  ['symbol-operator']                         = { icon = '', unicode = 0xEB64 },
  ['symbol-package']                          = { icon = '', unicode = 0xEA8B },
  ['symbol-parameter']                        = { icon = '', unicode = 0xEA92 },
  ['symbol-property']                         = { icon = '', unicode = 0xEB65 },
  ['symbol-reference']                        = { icon = '', unicode = 0xEA94 },
  ['symbol-ruler']                            = { icon = '', unicode = 0xEA96 },
  ['symbol-snippet']                          = { icon = '', unicode = 0xEB66 },
  ['symbol-string']                           = { icon = '', unicode = 0xEB8D },
  ['symbol-struct']                           = { icon = '', unicode = 0xEA91 },
  ['symbol-structure']                        = { icon = '', unicode = 0xEA91 },
  ['symbol-text']                             = { icon = '', unicode = 0xEA93 },
  ['symbol-type-parameter']                   = { icon = '', unicode = 0xEA92 },
  ['symbol-unit']                             = { icon = '', unicode = 0xEA96 },
  ['symbol-value']                            = { icon = '', unicode = 0xEA95 },
  ['symbol-variable']                         = { icon = '', unicode = 0xEA88 },
  ['sync']                                    = { icon = '', unicode = 0xEA77 },
  ['sync-ignored']                            = { icon = '', unicode = 0xEB9F },
  ['table']                                   = { icon = '', unicode = 0xEBB7 },
  ['tag']                                     = { icon = '', unicode = 0xEA66 },
  ['tag-add']                                 = { icon = '', unicode = 0xEA66 },
  ['tag-remove']                              = { icon = '', unicode = 0xEA66 },
  ['tasklist']                                = { icon = '', unicode = 0xEB67 },
  ['telescope']                               = { icon = '', unicode = 0xEB68 },
  ['terminal']                                = { icon = '', unicode = 0xEA85 },
  ['terminal-bash']                           = { icon = '', unicode = 0xEBCA },
  ['terminal-cmd']                            = { icon = '', unicode = 0xEBC4 },
  ['terminal-debian']                         = { icon = '', unicode = 0xEBC5 },
  ['terminal-linux']                          = { icon = '', unicode = 0xEBC6 },
  ['terminal-powershell']                     = { icon = '', unicode = 0xEBC7 },
  ['terminal-tmux']                           = { icon = '', unicode = 0xEBC8 },
  ['terminal-ubuntu']                         = { icon = '', unicode = 0xEBC9 },
  ['text-size']                               = { icon = '', unicode = 0xEB69 },
  ['three-bars']                              = { icon = '', unicode = 0xEB6A },
  ['thumbsdown']                              = { icon = '', unicode = 0xEB6B },
  ['thumbsup']                                = { icon = '', unicode = 0xEB6C },
  ['tools']                                   = { icon = '', unicode = 0xEB6D },
  ['trash']                                   = { icon = '', unicode = 0xEA81 },
  ['trashcan']                                = { icon = '', unicode = 0xEA81 },
  ['triangle-down']                           = { icon = '', unicode = 0xEB6E },
  ['triangle-left']                           = { icon = '', unicode = 0xEB6F },
  ['triangle-right']                          = { icon = '', unicode = 0xEB70 },
  ['triangle-up']                             = { icon = '', unicode = 0xEB71 },
  ['twitter']                                 = { icon = '', unicode = 0xEB72 },
  ['type-hierarchy']                          = { icon = '', unicode = 0xEBB9 },
  ['type-hierarchy-sub']                      = { icon = '', unicode = 0xEBBA },
  ['type-hierarchy-super']                    = { icon = '', unicode = 0xEBBB },
  ['unfold']                                  = { icon = '', unicode = 0xEB73 },
  ['ungroup-by-ref-type']                     = { icon = '', unicode = 0xEB98 },
  ['unlock']                                  = { icon = '', unicode = 0xEB74 },
  ['unmute']                                  = { icon = '', unicode = 0xEB75 },
  ['unverified']                              = { icon = '', unicode = 0xEB76 },
  ['variable']                                = { icon = '', unicode = 0xEA88 },
  ['variable-group']                          = { icon = '', unicode = 0xEBB8 },
  ['verified']                                = { icon = '', unicode = 0xEB77 },
  ['versions']                                = { icon = '', unicode = 0xEB78 },
  ['vm']                                      = { icon = '', unicode = 0xEA7A },
  ['vm-active']                               = { icon = '', unicode = 0xEB79 },
  ['vm-connect']                              = { icon = '', unicode = 0xEBA9 },
  ['vm-outline']                              = { icon = '', unicode = 0xEB7A },
  ['vm-running']                              = { icon = '', unicode = 0xEB7B },
  ['wand']                                    = { icon = '', unicode = 0xEBCF },
  ['warning']                                 = { icon = '', unicode = 0xEA6C },
  ['watch']                                   = { icon = '', unicode = 0xEB7C },
  ['whitespace']                              = { icon = '', unicode = 0xEB7D },
  ['whole-word']                              = { icon = '', unicode = 0xEB7E },
  ['window']                                  = { icon = '', unicode = 0xEB7F },
  ['word-wrap']                               = { icon = '', unicode = 0xEB80 },
  ['workspace-trusted']                       = { icon = '', unicode = 0xEBC1 },
  ['workspace-unknown']                       = { icon = '', unicode = 0xEBC3 },
  ['workspace-untrusted']                     = { icon = '', unicode = 0xEBC2 },
  ['wrench']                                  = { icon = '', unicode = 0xEB65 },
  ['wrench-subaction']                        = { icon = '', unicode = 0xEB65 },
  ['x']                                       = { icon = '', unicode = 0xEA76 },
  ['zap']                                     = { icon = '', unicode = 0xEA86 },
  ['zoom-in']                                 = { icon = '', unicode = 0xEB81 },
  ['zoom-out']                                = { icon = '', unicode = 0xEB82 },
}

-- Add indexing by unicode

---@param name string
---@param config codiconConfigNumbered
for name, config in pairs(vim.deepcopy(codicons)) do
  -- If it has a codicon defined for the unicode value, convert it to a list of names
  if codicons[config.unicode] then
    if type(codicons[config.unicode].name) ~= 'table' then
      codicons[config.unicode].name = { codicons[config.unicode].name }
    end
    table.insert(codicons[config.unicode].name, name)
  else
    codicons[config.unicode] = { name = name, icon = config.icon }
  end
end

---@type codiconConfigTable
return codicons

-- references:
-- 1. Linguist: https://github.com/github/linguist
-- 2. coc-explorer: https://github.com/weirongxu/coc-explorer/blob/59bd41f8fffdc871fbd77ac443548426bd31d2c3/src/icons.nerdfont.json#L2
-- 3. chad-tree: https://github.com/ms-jpq/chadtree/blob/f9f333c062/artifacts/icons.json
-- jquery = {
--   icon = "",
--   color = "#1B75BB"
-- },
-- angular = {
--   icon = "",
--   color = "#E23237"
-- },
-- backbone = {
--   icon = "",
--   color = "#0071B5"
-- },
-- requirejs = {
--   icon = "",
--   color = "#F44A41"
-- },
-- materialize = {
--   icon = "",
--   color = "#EE6E73"
-- },
-- mootools = {
--   icon = "",
--   color = "#ECECEC"
-- },
-- puppet = {
--   icon = "",
--   color = "#cbcb41"
-- },

local icons = {
  ["gruntfile"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "Gruntfile",
  },
  ["gulpfile"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "Gulpfile",
  },
  ["dropbox"] = {
    icon = "",
    color = "#0061FE",
    cterm_color = "27",
    name = "Dropbox",
  },
  ["xls"] = {
    icon = "",
    color = "#207245",
    cterm_color = "23",
    name = "Xls",
  },
  ["doc"] = {
    icon = "",
    color = "#185abd",
    cterm_color = "25",
    name = "Doc",
  },
  ["ppt"] = {
    icon = "",
    color = "#cb4a32",
    cterm_color = "167",
    name = "Ppt",
  },
  ["xml"] = {
    icon = "謹",
    color = "#e37933",
    cterm_color = "173",
    name = "Xml",
  },
  ["webpack"] = {
    icon = "ﰩ",
    color = "#519aba",
    cterm_color = "67",
    name = "Webpack",
  },
  [".settings.json"] = {
    icon = "",
    color = "#854CC7",
    cterm_color = "98",
    name = "SettingsJson",
  },
  ["cs"] = {
    icon = "",
    color = "#596706",
    cterm_color = "58",
    name = "Cs",
  },
  ["procfile"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Procfile",
  },
  ["svg"] = {
    icon = "ﰟ",
    color = "#FFB13B",
    cterm_color = "215",
    name = "Svg",
  },
  [".bashprofile"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "BashProfile",
  },
  [".bashrc"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Bashrc",
  },
  [".babelrc"] = {
    icon = "ﬥ",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Babelrc",
  },
  [".ds_store"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "DsStore",
  },
  ["git"] = {
    icon = "",
    color = "#F14C28",
    cterm_color = "202",
    name = "GitLogo",
  },
  [".gitattributes"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitAttributes",
  },
  [".gitconfig"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitConfig",
  },
  [".gitignore"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitIgnore",
  },
  [".gitmodules"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitModules",
  },
  ["COMMIT_EDITMSG"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitCommit",
  },
  ["COPYING"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "License",
  },
  ["COPYING.LESSER"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "License",
  },
  [".gitlab-ci.yml"] = {
    icon = "",
    color = "#e24329",
    cterm_color = "166",
    name = "GitlabCI",
  },
  [".gvimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Gvimrc",
  },
  [".npmignore"] = {
    icon = "",
    color = "#E8274B",
    cterm_color = "161",
    name = "NPMIgnore",
  },
  [".vimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Vimrc",
  },
  [".zshrc"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zshrc",
  },
  [".zshenv"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zshenv",
  },
  [".zprofile"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zshprofile",
  },
  ["Dockerfile"] = {
    icon = "",
    color = "#384d54",
    cterm_color = "59",
    name = "Dockerfile",
  },
  ["Gemfile$"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Gemfile",
  },
  ["LICENSE"] = {
    icon = "",
    color = "#d0bf41",
    cterm_color = "179",
    name = "License",
  },
  ["Vagrantfile$"] = {
    icon = "",
    color = "#1563FF",
    cterm_color = "27",
    name = "Vagrantfile",
  },
  ["_gvimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Gvimrc",
  },
  ["_vimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Vimrc",
  },
  ["ai"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Ai",
  },
  ["awk"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Awk",
  },
  ["bash"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Bash",
  },
  ["bat"] = {
    icon = "",
    color = "#C1F12E",
    cterm_color = "154",
    name = "Bat",
  },
  ["bmp"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Bmp",
  },
  ["c"] = {
    icon = "",
    color = "#599eff",
    cterm_color = "75",
    name = "C",
  },
  ["c++"] = {
    icon = "",
    color = "#f34b7d",
    cterm_color = "204",
    name = "CPlusPlus",
  },
  ["cc"] = {
    icon = "",
    color = "#f34b7d",
    cterm_color = "204",
    name = "CPlusPlus",
  },
  ["clj"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "107",
    name = "Clojure",
  },
  ["cljc"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "107",
    name = "ClojureC",
  },
  ["cljs"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "ClojureJS",
  },
  ["CMakeLists.txt"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "CMakeLists",
  },
  ["cmake"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "CMake",
  },
  ["cobol"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["cob"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["cbl"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["cpy"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["coffee"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Coffee",
  },
  ["conf"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Conf",
  },
  ["config.ru"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "ConfigRu",
  },
  ["cp"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Cp",
  },
  ["cpp"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Cpp",
  },
  ["cr"] = {
    icon = "",
    color = "#000000",
    cterm_color = "16",
    name = "Crystal",
  },
  ["csh"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Csh",
  },
  ["cson"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Cson",
  },
  ["css"] = {
    icon = "",
    color = "#563d7c",
    cterm_color = "60",
    name = "Css",
  },
  ["cxx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Cxx",
  },
  ["d"] = {
    icon = "",
    color = "#427819",
    cterm_color = "64",
    name = "D",
  },
  ["dart"] = {
    icon = "",
    color = "#03589C",
    cterm_color = "25",
    name = "Dart",
  },
  ["db"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Db",
  },
  ["diff"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "Diff",
  },
  ["dockerfile"] = {
    icon = "",
    color = "#384d54",
    cterm_color = "59",
    name = "Dockerfile",
  },
  ["dump"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Dump",
  },
  ["edn"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Edn",
  },
  ["eex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Eex",
  },
  ["ejs"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Ejs",
  },
  ["elm"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Elm",
  },
  ["erl"] = {
    icon = "",
    color = "#B83998",
    cterm_color = "132",
    name = "Erl",
  },
  ["ex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Ex",
  },
  ["exs"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Exs",
  },
  ["f#"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fsharp",
  },
  ["favicon.ico"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Favicon",
  },
  ["fish"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Fish",
  },
  ["fs"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fs",
  },
  ["fsi"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fsi",
  },
  ["fsscript"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fsscript",
  },
  ["fsx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fsx",
  },
  ["gemspec"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Gemspec",
  },
  ["gif"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Gif",
  },
  ["go"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Go",
  },
  ["h"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "H",
  },
  ["haml"] = {
    icon = "",
    color = "#eaeae1",
    cterm_color = "188",
    name = "Haml",
  },
  ["hbs"] = {
    icon = "",
    color = "#f0772b",
    cterm_color = "208",
    name = "Hbs",
  },
  ["heex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Heex",
  },
  ["hh"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hh",
  },
  ["hpp"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hpp",
  },
  ["hrl"] = {
    icon = "",
    color = "#B83998",
    cterm_color = "132",
    name = "Hrl",
  },
  ["hs"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hs",
  },
  ["htm"] = {
    icon = "",
    color = "#e34c26",
    cterm_color = "166",
    name = "Htm",
  },
  ["html"] = {
    icon = "",
    color = "#e34c26",
    cterm_color = "166",
    name = "Html",
  },
  ["erb"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Erb",
  },
  ["hxx"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hxx",
  },
  ["ico"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Ico",
  },
  ["ini"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Ini",
  },
  ["java"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "Java",
  },
  ["jl"] = {
    icon = "",
    color = "#a270ba",
    cterm_color = "133",
    name = "Jl",
  },
  ["jpeg"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Jpeg",
  },
  ["jpg"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Jpg",
  },
  ["js"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Js",
  },
  ["json"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Json",
  },
  ["jsx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Jsx",
  },
  ["ksh"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Ksh",
  },
  ["leex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Leex",
  },
  ["less"] = {
    icon = "",
    color = "#563d7c",
    cterm_color = "60",
    name = "Less",
  },
  ["lhs"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Lhs",
  },
  ["license"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "License",
  },
  ["lua"] = {
    icon = "",
    color = "#51a0cf",
    cterm_color = "74",
    name = "Lua",
  },
  ["makefile"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Makefile",
  },
  ["markdown"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Markdown",
  },
  ["md"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Md",
  },
  ["mdx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Mdx",
  },
  ["mix.lock"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "MixLock",
  },
  ["mjs"] = {
    icon = "",
    color = "#f1e05a",
    cterm_color = "221",
    name = "Mjs",
  },
  ["ml"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "173",
    name = "Ml",
  },
  ["mli"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "173",
    name = "Mli",
  },
  ["mustache"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "Mustache",
  },
  ["nix"] = {
    icon = "",
    color = "#7ebae4",
    cterm_color = "110",
    name = "Nix",
  },
  ["node_modules"] = {
    icon = "",
    color = "#E8274B",
    cterm_color = "161",
    name = "NodeModules",
  },
  ["php"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Php",
  },
  ["pl"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Pl",
  },
  ["pm"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Pm",
  },
  ["png"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Png",
  },
  ["pp"] = {
    icon = "",
    color = "#302B6D",
    cterm_color = "53",
    name = "Pp",
  },
  ["ps1"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "PromptPs1",
  },
  ["psb"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Psb",
  },
  ["psd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Psd",
  },
  ["py"] = {
    icon = "",
    color = "#3572A5",
    cterm_color = "61",
    name = "Py",
  },
  ["pyc"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Pyc",
  },
  ["pyd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Pyd",
  },
  ["pyo"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Pyo",
  },
  ["r"] = {
    icon = "ﳒ",
    color = "#358a5b",
    cterm_color = "65",
    name = "R",
  },
  ["R"] = {
    icon = "ﳒ",
    color = "#358a5b",
    cterm_color = "65",
    name = "R",
  },
  ["rake"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Rake",
  },
  ["rakefile"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Rakefile",
  },
  ["rb"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Rb",
  },
  ["Brewfile"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Brewfile"
  };
  ["Brewfile"] = {
    icon = "",
    color = "#701516",
    name = "Brewfile"
  };
  ["rlib"] = {
    icon = "",
    color = "#dea584",
    cterm_color = "180",
    name = "Rlib",
  },
  ["rmd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Rmd",
  },
  ["Rmd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Rmd",
  },
  ["rproj"] = {
    icon = "鉶",
    color = "#358a5b",
    cterm_color = "65",
    name = "Rproj",
  },
  ["rs"] = {
    icon = "",
    color = "#dea584",
    cterm_color = "180",
    name = "Rs",
  },
  ["rss"] = {
    icon = "",
    color = "#FB9D3B",
    cterm_color = "215",
    name = "Rss",
  },
  ["sass"] = {
    icon = "",
    color = "#f55385",
    cterm_color = "204",
    name = "Sass",
  },
  ["scala"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "Scala",
  },
  ["scss"] = {
    icon = "",
    color = "#f55385",
    cterm_color = "204",
    name = "Scss",
  },
  ["sh"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Sh",
  },
  ["sig"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "173",
    name = "Sig",
  },
  ["slim"] = {
    icon = "",
    color = "#e34c26",
    cterm_color = "166",
    name = "Slim",
  },
  ["sln"] = {
    icon = "",
    color = "#854CC7",
    cterm_color = "98",
    name = "Sln",
  },
  ["sml"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "173",
    name = "Sml",
  },
  ["sql"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Sql",
  },
  ["styl"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "107",
    name = "Styl",
  },
  ["suo"] = {
    icon = "",
    color = "#854CC7",
    cterm_color = "98",
    name = "Suo",
  },
  ["swift"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "Swift",
  },
  ["t"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Tor",
  },
  ["txt"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Txt"
  };
  ["txt"] = {
    icon = "",
    color = "#89e051",
    name = "Txt"
  };
  ["tex"] = {
    icon = "ﭨ",
    color = "#3D6117",
    cterm_color = "58",
    name = "Tex",
  },
  ["toml"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Toml",
  },
  ["ts"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Ts",
  },
  ["tsx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Tsx",
  },
  ["twig"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "107",
    name = "Twig",
  },
  ["vim"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Vim",
  },
  ["vue"] = {
    icon = "﵂",
    color = "#8dc149",
    cterm_color = "107",
    name = "Vue",
  },
  ["webmanifest"] = {
    icon = "",
    color = "#f1e05a",
    cterm_color = "221",
    name = "Webmanifest",
  },
  ["webp"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Webp",
  },
  ["xcplayground"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "XcPlayground",
  },
  ["xul"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "Xul",
  },
  ["yaml"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Yaml",
  },
  ["yml"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Yml",
  },
  ["zsh"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zsh",
  },
  ["terminal"] = {
    icon = "",
    color = "#31B53E",
    cterm_color = "71",
    name = "Terminal",
  },
  ["pdf"] = {
    icon = "",
    color = "#b30b00",
    cterm_color = "124",
    name = "Pdf",
  },
  ["kt"] = {
    icon = "𝙆",
    color = "#F88A02",
    cterm_color = "208",
    name = "Kotlin",
  },
  ["gd"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "GDScript",
  },
  ["tscn"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "TextScene",
  },
  ["godot"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "GodotProject",
  },
  ["tres"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "TextResource",
  },
  ["glb"] = {
    icon = "",
    color = "#FFB13B",
    cterm_color = "215",
    name = "BinaryGLTF",
  },
  ["import"] = {
    icon = "",
    color = "#ECECEC",
    cterm_color = "231",
    name = "ImportConfiguration",
  },
  ["material"] = {
    icon = "",
    color = "#B83998",
    cterm_color = "132",
    name = "Material",
  },
  ["otf"] = {
    icon = "",
    color = "#ECECEC",
    cterm_color = "231",
    name = "OpenTypeFont",
  },
  ["cfg"] = {
    icon = "",
    color = "#ECECEC",
    cterm_color = "231",
    name = "Configuration",
  },
  ["pck"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "PackedResource",
  },
  ["desktop"] = {
    icon = "",
    color = "#563d7c",
    cterm_color = "60",
    name = "DesktopEntry",
  },
  ["opus"] = {
    icon = "",
    color = "#F88A02",
    cterm_color = "208",
    name = "OPUS",
  },
  ["svelte"] = {
    icon = "",
    color = "#ff3e00",
    cterm_color = "202",
    name = "Svelte",
  },
  ["pro"] = {
    icon = "",
    color = "#e4b854",
    cterm_color = "179",
    name = "Prolog",
  },
  ["zig"] = {
    icon = "",
    color = "#f69a1b",
    cterm_color = "208",
    name = "Zig",
  },
  ['mint'] = {
    icon = "",
    color ='#87c095',
    cterm_color = "108",
    name = "Mint",
  },
}

local default_icon = {
  icon = "",
  color = "#6d8086",
  cterm_color = "66",
  name = "Default",
}

local global_opts = {
  override = {},
  default = false
}

local function get_highlight_name(data)
  return data.name and "DevIcon" .. data.name
end

local function set_up_highlight(icon_data)
  local hl_group = get_highlight_name(icon_data)
  if hl_group then
    local highlight_command = "highlight! "..hl_group

    if icon_data.color then
      highlight_command = highlight_command.." guifg="..icon_data.color
    end

    if icon_data.cterm_color then
      highlight_command = highlight_command.." ctermfg="..icon_data.cterm_color
    end

    if icon_data.color or icon_data.cterm_color then
      vim.api.nvim_command(highlight_command)
    end
  end
end

local function set_up_highlights()
  for _, icon_data in pairs(icons) do
    if (icon_data.color or icon_data.cterm_color) and icon_data.name then
      set_up_highlight(icon_data)
    end
  end
end

local loaded = false

local function setup(opts)
  if loaded then return end

  loaded = true

  local user_icons = opts or {}

  if user_icons.default then
    global_opts.default = true
  end

  if user_icons.override and user_icons.override.default_icon then
    default_icon = user_icons.override.default_icon
  end

  icons = vim.tbl_extend("force", icons, user_icons.override or {});

  table.insert(icons, default_icon)

  set_up_highlights()

  vim.cmd [[augroup NvimWebDevicons]]
  vim.cmd [[autocmd!]]
  vim.cmd [[autocmd ColorScheme * lua require('nvim-web-devicons').set_up_highlights()]]
  vim.cmd [[augroup END]]
end

local function get_icon(name, ext, opts)
  ext = ext or name:match("^.*%.(.*)$") or ""
  if not loaded then
    setup()
  end

  local has_default = (opts and opts.default) or global_opts.default
  local icon_data = icons[name] or icons[ext] or (has_default and default_icon)

  if icon_data then
    return icon_data.icon, get_highlight_name(icon_data)
  end
end

local function get_icon_colors(name, ext, opts)
  ext = ext or name:match("^.*%.(.*)$") or ""
  if not loaded then
    setup()
  end

  local has_default = (opts and opts.default) or global_opts.default
  local icon_data = icons[name] or icons[ext] or (has_default and default_icon)

  if icon_data then
    return icon_data.icon, icon_data.color, icon_data.cterm_color
  end
end

local function get_icon_color(name, ext, opts)
  local data = { get_icon_colors(name, ext, opts) }
  return data[1], data[2]
end

local function get_icon_cterm_color(name, ext, opts)
  local data = { get_icon_colors(name, ext, opts) }
  return data[1], data[3]
end

local function set_icon(user_icons)
  icons = vim.tbl_extend("force", icons, user_icons or {})
  for _, icon_data in pairs(user_icons) do
    set_up_highlight(icon_data)
  end
end

local function set_default_icon(icon, color, cterm_color)
  default_icon.icon = icon
  default_icon.color = color
  default_icon.cterm_color = cterm_color
  set_up_highlight(default_icon)
end

return {
  get_icon = get_icon,
  get_icon_colors = get_icon_colors,
  get_icon_color = get_icon_color,
  get_icon_cterm_color = get_icon_cterm_color,
  set_icon = set_icon,
  set_default_icon = set_default_icon,
  setup = setup,
  has_loaded = function() return loaded end,
  get_icons = function() return icons end,
  set_up_highlights = set_up_highlights,
}
