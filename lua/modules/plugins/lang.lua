local lang = {}

lang["fatih/vim-go"] = {
	lazy = true,
	ft = "go",
	build = ":GoInstallBinaries",
	config = require("lang.vim-go"),
}
lang["simrat39/rust-tools.nvim"] = {
	lazy = true,
	ft = "rust",
	config = require("lang.rust-tools"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufReadPost Cargo.toml",
	config = require("lang.crates"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = ":call mkdp#util#install()",
}
lang["chrisbra/csv.vim"] = {
	lazy = true,
	ft = "csv",
}
lang["chrisbra/csv.vim"] = { opt = true, ft = "csv" }

lang["lervag/vimtex"] = { config = require("lang.vim-tex") }

lang["ShinKage/idris2-nvim"] = {
	lazy = true,
	ft = "idris2",
	config = require("lang.idris"),
	dependencies = { "neovim/nvim-lspconfig", "MunifTanjim/nui.nvim" },
}

return lang
