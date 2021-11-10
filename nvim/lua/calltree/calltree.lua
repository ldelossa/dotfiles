local log = require 'vim.lsp.log'
local protocol = require 'vim.lsp.protocol'
local util = require 'vim.lsp.util'
local vim = vim
local api = vim.api

M = {}
function M.call_hierarchy_handler(_, result, ctx, _)
    print("in call_hierarchy_handler")
    print("root identifier: " .. ctx.params.item.name)
    print(vim.inspect(result))
    --[[ if not result then return end
    local items = {}
    print(vim.inspect(ctx))
    for _, call_hierarchy_call in pairs(result) do
      local call_hierarchy_item = call_hierarchy_call['from']
      for _, range in pairs(call_hierarchy_call.fromRanges) do
        table.insert(items, {
          filename = assert(vim.uri_to_fname(call_hierarchy_item.uri)),
          text = call_hierarchy_item.name,
          lnum = range.start.line + 1,
          col = range.start.character + 1,
        })
      end
    end
    util.set_qflist(items)
    api.nvim_command("copen") ]]
end
return M
