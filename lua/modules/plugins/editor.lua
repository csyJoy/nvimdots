local editor = {}

-- 会话管理：自动保存和恢复 Neovim 会话
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
-- 自动闭合括号：自动闭合括号、引号等配对符号
editor["m4xshen/autoclose.nvim"] = {
	lazy = true,
	event = "InsertEnter",
	config = require("editor.autoclose"),
}
-- 大文件优化：加快大文件加载速度
editor["pteroctopus/faster.nvim"] = {
	lazy = false,
	cond = require("core.settings").load_big_files_faster,
	config = require("editor.faster"),
}
-- Buffer 删除管理：提供更好的 buffer 删除命令（BufDel, BufDelAll, BufDelOthers）
editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
}
-- NOTE: `flash.nvim` 是一个强大的插件，可以部分或完全替代：
--  > `hop.nvim`，
--  > `wilder.nvim`
--  > `nvim-treehopper`
-- 考虑到其陡峭的学习曲线以及向后兼容性问题...
--  > 我们暂时没有计划移除上述插件。
-- 但像往常一样，你可以根据自己的喜好调整插件配置。
-- 增强型跳转插件：提供可视化提示的快速跳转功能
editor["folke/flash.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.flash"),
}
-- 智能注释：提供智能注释和取消注释功能
editor["numToStr/Comment.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.comment"),
}
-- Git 差异查看器：提供统一的 Git 差异查看界面
editor["sindrets/diffview.nvim"] = {
	lazy = true,
	cmd = { "DiffviewOpen", "DiffviewClose" },
	config = require("editor.diffview"),
}
-- 文本对齐：提供基于模式和动作的文本对齐功能
editor["echasnovski/mini.align"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.align"),
}
-- 光标下单词高亮：高亮或下划线光标下的单词
editor["echasnovski/mini.cursorword"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("editor.cursorword"),
}
-- 快速导航跳转：强大的快速导航插件
editor["smoka7/hop.nvim"] = {
	lazy = true,
	version = "*",
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.hop"),
}
-- 颜色值可视化：将颜色值显示为高亮
editor["brenoprata10/nvim-highlight-colors"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.highlight-colors"),
}
-- 智能搜索高亮：自动禁用不需要的搜索高亮
editor["romainl/vim-cool"] = {
	lazy = true,
	event = { "CursorMoved", "InsertEnter" },
}
-- Sudo 权限编辑：使用 sudo 权限编辑文件
editor["lambdalisue/suda.vim"] = {
	lazy = true,
	cmd = { "SudaRead", "SudaWrite" },
	init = require("editor.suda"),
}
-- 自动检测缩进：自动检测和设置文件的缩进风格
editor["tpope/vim-sleuth"] = {
	lazy = true,
	event = { "BufNewFile", "BufReadPost", "BufFilePost" },
}
-- 查找和替换 UI：提供可视化的查找和替换界面
editor["MagicDuck/grug-far.nvim"] = {
	lazy = true,
	cmd = "GrugFar",
	config = require("editor.grug-far"),
}
----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
-- Treesitter 核心：提供语法树解析和增强的语法高亮功能
editor["nvim-treesitter/nvim-treesitter"] = {
	lazy = true,
	build = function()
		if #vim.api.nvim_list_uis() > 0 then
			vim.api.nvim_command([[TSUpdate]])
		end
	end,
	event = "BufReadPre",
	config = require("editor.treesitter"),
	dependencies = {
		{ "mfussenegger/nvim-treehopper" },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{
			"andymass/vim-matchup",
			init = require("editor.matchup"),
		},
		{
			"windwp/nvim-ts-autotag",
			config = require("editor.autotag"),
		},
		-- {
		-- 	"hiphish/rainbow-delimiters.nvim",
		-- 	config = require("editor.rainbow_delims"),
		-- },
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

return editor
