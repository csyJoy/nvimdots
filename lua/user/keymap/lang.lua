local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
require("keymap.helpers")

local plug_map = {
	-- Plugin vimtex
	["n|<leader>ls"] = map_cmd("<Plug>(vimtex-view)"):with_silent():with_desc("view current tex"),
	["n|<leader>lc"] = map_cmd("<Plug>(vimtex-compile)"):with_silent():with_desc("compile current tex"),
	["n|<leader>lt"] = map_cmd("<Plug>(vimtex-toc-open)"):with_silent():with_desc("open pdf"),
}

return plug_map