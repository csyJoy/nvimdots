local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

local plug_map = {
	-- Plugin: nvim-bufdel
	["n|dq"] = map_cr("BufDel"):with_noremap():with_silent():with_desc("buffer: Close current"),
	-- Plugin: vim-easy-align
	["n|<leader>ea"] = map_callback(function()
			return et("<Plug>(EasyAlign)")
		end)
		:with_expr()
		:with_desc("edit: Align with delimiter"),
	["x|<leader>ea"] = map_callback(function()
			return et("<Plug>(EasyAlign)")
		end)
		:with_expr()
		:with_desc("edit: Align with delimiter"),

	-- Plugin: flash.nvim
	["n|S"] = map_callback(function()
			require("flash").jump()
		end)
		:with_noremap()
		:with_desc("flash: search words"),
	["x|S"] = map_callback(function()
			require("flash").jump()
		end)
		:with_noremap()
		:with_desc("flash: search words"),
	["o|S"] = map_callback(function()
			require("flash").jump()
		end)
		:with_noremap()
		:with_desc("flash: search words"),
	["o|r"] = map_callback(function()
			require("flash").remote()
		end)
		:with_noremap()
		:with_desc("flash: remote"),
	["x|R"] = map_callback(function()
			require("flash").treesitter_search()
		end)
		:with_noremap()
		:with_desc("flash: treesitter search"),
	["o|R"] = map_callback(function()
			require("flash").treesitter_search()
		end)
		:with_noremap()
		:with_desc("flash: treesitter search"),
	["n|<leader>so"] = map_cu("SudaWrite"):with_silent():with_noremap():with_desc("editn: Save file using sudo"),
}

return plug_map
