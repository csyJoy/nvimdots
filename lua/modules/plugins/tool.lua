local tool = {}
local settings = require("core.settings")

-- Git 集成：提供强大的 Git 命令和集成功能
tool["tpope/vim-fugitive"] = {
	lazy = true,
	cmd = { "Git", "G" },
}
-- This is specifically for fcitx5 users who code in languages other than English
-- tool["pysan3/fcitx5.nvim"] = {
-- 	lazy = true,
-- 	event = "BufReadPost",
-- 	cond = vim.fn.executable("fcitx5-remote") == 1,
-- 	config = require("tool.fcitx5"),
-- }
-- 面包屑导航栏：显示当前文件的上下文和导航路径
tool["Bekaboo/dropbar.nvim"] = {
	lazy = false,
	config = require("tool.dropbar"),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-fzf-native.nvim",
	},
}
-- 文件浏览器：侧边栏文件树浏览器
tool["nvim-tree/nvim-tree.lua"] = {
	lazy = true,
	cmd = {
		"NvimTreeToggle",
		"NvimTreeOpen",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeRefresh",
	},
	config = require("tool.nvim-tree"),
}
-- 智能复制：智能复制到系统剪贴板
tool["ibhagwan/smartyank.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.smartyank"),
}
-- 代码片段执行：在编辑器中直接执行代码片段
tool["michaelb/sniprun"] = {
	lazy = true,
	-- If you see an error about a missing SnipRun executable,
	-- run `bash ./install.sh` inside `~/.local/share/nvim/site/lazy/sniprun/`.
	build = "bash ./install.sh",
	cmd = { "SnipRun", "SnipReset", "SnipInfo" },
	config = require("tool.sniprun"),
}
-- 终端多路复用器：浮动和分割终端管理
tool["akinsho/toggleterm.nvim"] = {
	lazy = true,
	cmd = {
		"ToggleTerm",
		"ToggleTermSetName",
		"ToggleTermToggleAll",
		"ToggleTermSendVisualLines",
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualSelection",
	},
	config = require("tool.toggleterm"),
}
-- 诊断列表增强：更好的诊断和 quickfix 列表
tool["folke/trouble.nvim"] = {
	lazy = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = require("tool.trouble"),
}
-- 快捷键助手：显示可用的快捷键和描述
tool["folke/which-key.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("tool.which-key"),
}
-- 命令行增强：增强的命令行补全 UI
tool["gelguy/wilder.nvim"] = {
	lazy = true,
	event = "CmdlineEnter",
	config = require("tool.wilder"),
	dependencies = "romgrk/fzy-lua-native",
}
-- AI 代码助手：AI 驱动的代码助手（可选启用）
if settings.use_chat then
	tool["olimorris/codecompanion.nvim"] = {
		lazy = true,
		tag = "v17.33.0",
		event = "VeryLazy",
		config = require("tool.codecompanion"),
		dependencies = {
			{ "ravitemer/codecompanion-history.nvim" },
		},
	}
end
-- FZF 模糊查找器：基于 fzf 的模糊查找器（可选，需要 fzf 命令）
-- Needs `fzf` installed and in $PATH
tool["ibhagwan/fzf-lua"] = {
	lazy = true,
	cond = (settings.search_backend == "fzf"),
	cmd = "FzfLua",
	config = require("tool.fzf-lua"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
}

----------------------------------------------------------------------
--                        Telescope 插件                            --
----------------------------------------------------------------------
-- Telescope 核心：强大的模糊查找框架（文件、符号、命令等）
tool["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = require("tool.telescope"),
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
		{ "jvgrootveld/telescope-zoxide" },
		{ "debugloop/telescope-undo.nvim" },
		{ "nvim-telescope/telescope-frecency.nvim" },
		{ "nvim-telescope/telescope-live-grep-args.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{
			"ayamir/search.nvim",
			config = require("tool.search"),
		},
		{
			"DrKJeff16/project.nvim",
			event = { "CursorHold", "CursorHoldI" },
			config = require("tool.project"),
		},
		{
			"aaronhallaert/advanced-git-search.nvim",
			cmd = { "AdvancedGitSearch" },
			dependencies = {
				"tpope/vim-rhubarb",
				"tpope/vim-fugitive",
				"sindrets/diffview.nvim",
			},
		},
	},
}

----------------------------------------------------------------------
--                           DAP 插件                               --
----------------------------------------------------------------------
-- DAP 核心：调试适配器协议客户端，支持多种语言调试
tool["mfussenegger/nvim-dap"] = {
	lazy = true,
	cmd = {
		"DapSetLogLevel",
		"DapShowLog",
		"DapContinue",
		"DapToggleBreakpoint",
		"DapToggleRepl",
		"DapStepOver",
		"DapStepInto",
		"DapStepOut",
		"DapTerminate",
	},
	config = require("tool.dap"),
	dependencies = {
		{ "jay-babu/mason-nvim-dap.nvim" },
		{
			"rcarriga/nvim-dap-ui",
			dependencies = "nvim-neotest/nvim-nio",
			config = require("tool.dap.dapui"),
		},
	},
}

return tool
