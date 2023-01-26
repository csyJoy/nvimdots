local lang = {}
local conf = require("modules.lang.config")

lang["fatih/vim-go"] = {
	lazy = true,
	ft = "go",
	build = ":GoInstallBinaries",
	config = conf.lang_go,
}
lang["simrat39/rust-tools.nvim"] = {
	lazy = true,
	ft = "rust",
	config = conf.rust_tools,
	dependencies = { { "nvim-lua/plenary.nvim" } },
}
lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = "cd app && yarn install",
}
lang["chrisbra/csv.vim"] = {
	lazy = true,
	ft = "csv",
}
lang["chrisbra/csv.vim"] = { opt = true, ft = "csv" }

lang["lervag/vimtex"] = { config = conf.vim_tex }

return lang
