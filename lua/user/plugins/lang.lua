local lang = {}

-- CSV 文件支持：提供 CSV 文件编辑功能
lang["chrisbra/csv.vim"] = { opt = true, ft = "csv" }

-- LaTeX 支持：提供 LaTeX 文档编辑和编译支持
lang["lervag/vimtex"] = {
	ft = "tex",
	config = require("lang.vim-tex"),
}

-- Idris2 语言支持：提供 Idris2 语言支持和 LSP 集成
lang["ShinKage/idris2-nvim"] = {
	ft = "idris2",
	config = require("lang.idris"),
	dependencies = { "neovim/nvim-lspconfig", "MunifTanjim/nui.nvim" },
}

-- Agda 语言支持：提供 Agda 依赖类型编程语言支持
lang["ashinkarov/nvim-agda"] = {
	ft = "agda",
}

return lang
