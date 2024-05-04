local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
require("keymap.helpers")

local plug_map = {
	["n|<C-h>"] = map_callback(function()
			require("smart-splits").move_cursor_left()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Left"),
	["n|<C-l>"] = map_callback(function()
			require("smart-splits").move_cursor_right()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Right"),
	["n|<C-k>"] = map_callback(function()
			require("smart-splits").move_cursor_up()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Up"),
	["n|<C-j>"] = map_callback(function()
			require("smart-splits").move_cursor_down()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Down"),
	["t|<C-h>"] = map_callback(function()
			require("smart-splits").move_cursor_left()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Left"),
	["t|<C-l>"] = map_callback(function()
			require("smart-splits").move_cursor_right()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Right"),
	["t|<C-k>"] = map_callback(function()
			require("smart-splits").move_cursor_up()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Up"),
	["t|<C-j>"] = map_callback(function()
			require("smart-splits").move_cursor_down()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Down"),
	["n|<C-S-h>"] = map_callback(function()
			require("smart-splits").resize_left()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Left"),
	["n|<C-S-l>"] = map_callback(function()
			require("smart-splits").resize_right()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Right"),
	["n|<C-S-k>"] = map_callback(function()
			require("smart-splits").resize_up()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Up"),
	["n|<C-S-j>"] = map_callback(function()
			require("smart-splits").resize_down()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("window: Focus Down"),
	["n|<C-q>"] = map_cmd(":wq<CR>"):with_desc("editn: Save file and quit"),
	["n|<A-S-q>"] = map_cmd(":q!<CR>"):with_desc("editn: Force quit"),
	["n|<leader>sp"] = map_cr("setlocal spell! spelllang=en_us"):with_desc("editn: Toggle spell check"),
}

return plug_map
