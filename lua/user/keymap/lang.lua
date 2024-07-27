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
	["n|\\c"] = map_callback(function()
			require("idris2.code_action").case_split()
		end)
		:with_silent()
		:with_desc("idris2: case_split"),
	["n|\\mc"] = map_callback(function()
			require("idris2.code_action").make_case()
		end)
		:with_silent()
		:with_desc("idris2: make_case"),
	["n|\\mw"] = map_callback(function()
			require("idris2.code_action").make_with()
		end)
		:with_silent()
		:with_desc("idris2: make_with"),
	["n|\\ml"] = map_callback(function()
			require("idris2.code_action").make_lemma()
		end)
		:with_silent()
		:with_desc("idris2: make_lemma"),
	["n|\\a"] = map_callback(function()
			require("idris2.code_action").add_clause()
		end)
		:with_silent()
		:with_desc("idris2: add_clause"),
	["n|\\o"] = map_callback(function()
			require("idris2.code_action").expr_search()
		end)
		:with_silent()
		:with_desc("idris2: expr_search"),
	["n|\\gd"] = map_callback(function()
			require("idris2.code_action").generate_def()
		end)
		:with_silent()
		:with_desc("idris2: generate_def"),
	["n|\\rh"] = map_callback(function()
			require("idris2.code_action").refine_hole()
		end)
		:with_silent()
		:with_desc("idris2: refine_hole"),
	["n|\\so"] = map_callback(function()
			require("idris2.hover").open_split()
		end)
		:with_silent()
		:with_desc("idris2: open_split"),
	["n|\\sc"] = map_callback(function()
			require("idris2.hover").close_split()
		end)
		:with_silent()
		:with_desc("idris2: close_split"),
	["n|\\mm"] = map_callback(function()
			require("idris2.metavars").request_all()
		end)
		:with_silent()
		:with_desc("idris2: request_all"),
	["n|\\mn"] = map_callback(function()
			require("idris2.metavars").goto_next()
		end)
		:with_silent()
		:with_desc("idris2: goto_next"),
	["n|\\mp"] = map_callback(function()
			require("idris2.metavars").goto_prev()
		end)
		:with_silent()
		:with_desc("idris2: goto_prev"),
	["n|\\br"] = map_callback(function()
			require("idris2.browse").browse()
		end)
		:with_silent()
		:with_desc("idris2: browse"),
	["n|\\x"] = map_callback(function()
			require("idris2.repl").evaluate()
		end)
		:with_silent()
		:with_desc("idris2: evaluate"),
}

return plug_map
