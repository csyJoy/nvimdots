local completion = {}

-- LSP 配置和管理：为语言服务器提供配置和管理功能
completion["neovim/nvim-lspconfig"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("completion.lsp"),
	dependencies = {
		{ "mason-org/mason.nvim" },
		{ "mason-org/mason-lspconfig.nvim" },
		{ "folke/neoconf.nvim" },
		{
			"Jint-lzxy/lsp_signature.nvim",
			config = require("completion.lsp-signature"),
		},
	},
}
-- 增强型 LSP UI：提供增强的代码操作、定义预览和悬停信息 UI
completion["nvimdev/lspsaga.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.lspsaga"),
	dependencies = "nvim-tree/nvim-web-devicons",
}
-- 快速预览窗口：提供快速查看定义、引用和实现的预览窗口
completion["DNLHC/glance.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.glance"),
}
-- 行内诊断显示：在代码行内显示诊断信息
completion["rachartier/tiny-inline-diagnostic.nvim"] = {
	lazy = false,
	config = require("completion.tiny-inline-diagnostic"),
}
-- 格式化修改行：仅格式化 Git 版本控制中修改的行
completion["joechrisellis/lsp-format-modifications.nvim"] = {
	lazy = true,
	event = "LspAttach",
}
-- 外部工具集成：集成外部诊断、格式化和代码操作工具（null-ls 的 fork）
completion["nvimtools/none-ls.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("completion.null-ls"),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
}
-- 自动补全引擎：提供强大的自动补全功能，支持多种补全源
completion["hrsh7th/nvim-cmp"] = {
	lazy = true,
	event = "InsertEnter",
	config = require("completion.cmp"),
	opts = function(_, opts)
		opts.sources = opts.sources or {}
		table.insert(opts.sources, {
			name = "lazydev",
			group_index = 0, -- set group index to 0 to skip loading LuaLS completions
		})
	end,
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
			config = require("completion.luasnip"),
			dependencies = "rafamadriz/friendly-snippets",
		},
		{ "lukas-reineke/cmp-under-comparator" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "andersevenrud/cmp-tmux" },
		{ "hrsh7th/cmp-path" },
		{ "f3fora/cmp-spell" },
		{ "hrsh7th/cmp-buffer" },
		{ "kdheepak/cmp-latex-symbols" },
	},
}
-- GitHub Copilot 集成：集成 GitHub Copilot AI 代码补全（可选启用）
completion["zbirenbaum/copilot.lua"] = {
	lazy = true,
	cond = require("core.settings").use_copilot,
	cmd = "Copilot",
	event = "InsertEnter",
	config = require("completion.copilot"),
	dependencies = {
		{
			"zbirenbaum/copilot-cmp",
			config = require("completion.copilot-cmp"),
		},
	},
}

return completion
