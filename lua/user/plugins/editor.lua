local editor = {}

editor["max397574/better-escape.nvim"] = {
	lazy = true,
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
	config = require("editor.focus"),
}

editor["folke/todo-comments.nvim"] = {
	lazy = true,
	event = "BufRead",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = require("editor.todo-comments"),
	opts = {},
}

return editor
