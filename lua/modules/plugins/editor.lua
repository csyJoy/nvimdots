local editor = {}

editor["olimorris/persisted.nvim"] = {
	lazy = true,
	cmd = {
		"SessionToggle",
		"SessionStart",
		"SessionStop",
		"SessionSave",
		"SessionLoad",
		"SessionLoadLast",
		"SessionLoadFromFile",
		"SessionDelete",
	},
	config = require("editor.persisted"),
}
editor["m4xshen/autoclose.nvim"] = {
	lazy = true,
	event = "InsertEnter",
	config = require("editor.autoclose"),
}
editor["LunarVim/bigfile.nvim"] = {
	lazy = false,
	config = require("editor.bigfile"),
	cond = require("core.settings").load_big_files_faster,
}
editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
}
-- NOTE: `flash.nvim` is a powerful plugin that can be used as partial or complete replacements for:
--  > `hop.nvim`,
--  > `wilder.nvim`
--  > `nvim-treehopper`
-- Considering its steep learning curve as well as backward compatibility issues...
--  > We have no plan to remove the above plugins for the time being.
-- But as usual, you can always tweak the plugin to your liking.
editor["folke/flash.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.flash"),
}
editor["numToStr/Comment.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.comment"),
}
editor["sindrets/diffview.nvim"] = {
	lazy = true,
	cmd = { "DiffviewOpen", "DiffviewClose" },
	config = require("editor.diffview"),
}
editor["echasnovski/mini.align"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.align"),
}
editor["tzachar/local-highlight.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.local-highlight"),
}
editor["romainl/vim-cool"] = {
	lazy = true,
	event = { "CursorMoved", "InsertEnter" },
}
editor["lambdalisue/suda.vim"] = {
	lazy = true,
	cmd = { "SudaRead", "SudaWrite" },
	init = require("editor.suda"),
}
editor["tpope/vim-sleuth"] = {
	lazy = true,
	event = { "BufNewFile", "BufReadPost", "BufFilePost" },
}
editor["nvim-pack/nvim-spectre"] = {
	lazy = true,
	cmd = "Spectre",
}
editor["mrjones2014/smart-splits.nvim"] = {
	lazy = true,
	event = { "CursorHoldI", "CursorHold" },
	config = require("editor.splits"),
}

editor["folke/todo-comments.nvim"] = {
	lazy = true,
	event = "BufRead",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = require("editor.todo-comments"),
	opts = {},
}

----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
editor["nvim-treesitter/nvim-treesitter"] = {
	lazy = true,
	build = function()
		if #vim.api.nvim_list_uis() ~= 0 then
			vim.api.nvim_command([[TSUpdate]])
		end
	end,
	event = "BufReadPre",
	config = require("editor.treesitter"),
	dependencies = {
		{ "andymass/vim-matchup" },
		{ "mfussenegger/nvim-treehopper" },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{
			"windwp/nvim-ts-autotag",
			config = require("editor.autotag"),
		},
		{
			"NvChad/nvim-colorizer.lua",
			config = require("editor.colorizer"),
		},
		{
			"hiphish/rainbow-delimiters.nvim",
			config = require("editor.rainbow_delims"),
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = require("editor.ts-context"),
		},
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			config = require("editor.ts-context-commentstring"),
		},
	},
}
editor["kylechui/nvim-surround"] = {
	version = "*",
	event = "VeryLazy",
	config = require("editor.nvim-surround"),
}

editor["nvim-focus/focus.nvim"] = {
	version = false,
	config = require("editor.focus"),
}

editor["max397574/better-escape.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.better-escape"),
}

return editor
