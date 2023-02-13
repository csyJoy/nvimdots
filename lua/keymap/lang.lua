local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
-- local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
-- local map_callback = bind.map_callback

local plug_map = {
	-- Plugin MarkdownPreview
	["n|<F12>"] = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent():with_desc("tool: Preview markdown"),

	-- Plugin vimtex
	["n|<leader>ls"] = map_cmd([[<Plug>(vimtex-view)]]):with_silent(),
	["n|<leader>lc"] = map_cmd([[<Plug>(vimtex-compile)]]):with_silent(),
	["n|<leader>lt"] = map_cmd([[<Plug>(vimtex-toc-open)]]):with_silent(),
}

bind.nvim_load_mapping(plug_map)
