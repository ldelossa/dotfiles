require("vertical_tabs")

local session = require('session')
local webview = require('webview')

webview.add_signal("init", function (view)
    view:add_signal("navigation-request", function (v, uri)
        if string.match(string.lower(uri), "^mailto:") then
            local mailto = "https://mail.google.com/mail/?extsrc=mailto&url=%s"
            local w = window.ancestor(v)
            w:new_tab(string.format(mailto, uri))
            return false
        end
        if string.match(string.lower(uri), "^zoommtg:") then
            local cmd = string.format('%s %q', "zoom", uri)
            os.execute(cmd)
            return false
        end
    end)
end)

function work()
    tmp = session.session_file
    session.session_file = "/home/louis/.config/luakit/sessions/work"
    session.restore(false)
    session.session_file = tmp
end
