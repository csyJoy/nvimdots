local editor = {}

editor["max397574/better-escape.nvim"] = {
	lazy = true,
	tag = "v1.0.0",
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.better-escape"),
}

editor["kylechui/nvim-surround"] = {
	version = "*",
	event = "VeryLazy",
	config = require("editor.nvim-surround"),
}

editor["nvim-focus/focus.nvim"] = {
	version = false,
	enabled = false,
	config = require("editor.focus"),
}

editor["folke/todo-comments.nvim"] = {
	lazy = true,
	event = "BufRead",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = require("editor.todo-comments"),
	opts = {},
}

editor["romgrk/barbar.nvim"] = {
	dependencies = {
		"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
		"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
		-- animation = true,
		-- insert_at_start = true,
		-- …etc.
	},
	version = "^1.0.0", -- optional: only update when a new 1.x version is released
}

return editor
