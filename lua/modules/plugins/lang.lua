local lang = {}

-- 增强型 Quickfix 窗口：提供更好的 quickfix 窗口，支持过滤和编辑
lang["kevinhwang91/nvim-bqf"] = {
	lazy = true,
	ft = "qf",
	config = require("lang.bqf"),
	dependencies = {
		{ "junegunn/fzf", build = ":call fzf#install()" },
	},
}
-- Go 语言支持：提供 Go 语言开发工具和实用功能
lang["ray-x/go.nvim"] = {
	lazy = true,
	ft = { "go", "gomod", "gosum" },
	build = ":GoInstallBinaries",
	config = require("lang.go"),
	dependencies = "ray-x/guihua.lua",
}
-- Rust 语言支持：提供 Rust 语言支持和调试集成
lang["mrcjkb/rustaceanvim"] = {
	lazy = true,
	ft = "rust",
	version = "*",
	init = require("lang.rust"),
	dependencies = "nvim-lua/plenary.nvim",
}
-- Cargo.toml 管理：在 Cargo.toml 中管理 crate 版本
lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufReadPost Cargo.toml",
	config = require("lang.crates"),
	dependencies = "nvim-lua/plenary.nvim",
}
-- Markdown 渲染：在 Neovim 中渲染 Markdown 内容
lang["MeanderingProgrammer/render-markdown.nvim"] = {
	lazy = true,
	ft = { "markdown", "codecompanion" },
	config = require("lang.render-markdown"),
}
-- Markdown 预览：在浏览器中实时预览 Markdown
lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = ":call mkdp#util#install()",
}
-- CSV 文件支持：提供 CSV 文件编辑功能
lang["chrisbra/csv.vim"] = {
	lazy = true,
	ft = "csv",
}
return lang
