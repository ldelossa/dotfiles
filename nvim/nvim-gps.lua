-- Lua

-- Example config
require("nvim-gps").setup({
	icons = {
		["class-name"] = 'ﴯ ',      -- Classes and class-like objects
		["function-name"] = ' ',   -- Functions
		["method-name"] = ' '      -- Methods (functions inside class-like objects)
	},
	-- Disable any languages individually over here
	-- Any language not disabled here is enabled by default
	languages = {
		-- ["bash"] = false,
		-- ["go"] = false,
	},
	separator = ' > ',
})
