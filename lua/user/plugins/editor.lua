local editor = {}

editor["max397574/better-escape.nvim"] = {
	lazy = true,
	tag = "v1.0.0",
	event = { "CursorHold", "CursorHoldI" },
	config = require("user.configs.editor.better-escape"),
}

editor["kylechui/nvim-surround"] = {
	version = "*",
	event = "VeryLazy",
	config = require("user.configs.editor.nvim-surround"),
}

editor["nvim-focus/focus.nvim"] = {
	version = false,
	config = require("user.configs.editor.focus"),
}

editor["folke/todo-comments.nvim"] = {
	lazy = true,
	event = "BufRead",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = require("user.configs.editor.todo-comments"),
	opts = {},
}

editor["echasnovski/mini.align"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("user.configs.editor.align"),
}

return editor
