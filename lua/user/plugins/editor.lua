local editor = {}

-- 快速 Escape 替代：提供更快的 Escape 键替代方案（如 Alt+j）
editor["max397574/better-escape.nvim"] = {
	lazy = true,
	tag = "v1.0.0",
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.better-escape"),
}

-- 环绕文本对象：管理环绕文本的括号、引号等
editor["kylechui/nvim-surround"] = {
	version = "*",
	event = "VeryLazy",
	config = require("editor.nvim-surround"),
}

-- 自动窗口聚焦：自动窗口聚焦管理（已禁用）
editor["nvim-focus/focus.nvim"] = {
	version = false,
	enabled = false,
	config = require("editor.focus"),
}

-- TODO 注释高亮：高亮 TODO、FIXME、NOTE 等注释
editor["folke/todo-comments.nvim"] = {
	lazy = true,
	event = "BufRead",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = require("editor.todo-comments"),
	opts = {},
}

-- Buffer 标签栏（barbar）：另一个 buffer 标签栏插件（未启用）
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
