local lang = {}

lang["kevinhwang91/nvim-bqf"] = {
	lazy = true,
	ft = "qf",
	config = require("lang.bqf"),
	dependencies = {
		{ "junegunn/fzf", build = ":call fzf#install()" },
	},
}
lang["fatih/vim-go"] = {
	lazy = true,
	ft = "go",
	build = ":GoInstallBinaries",
	init = require("lang.vim-go"),
}
lang["mrcjkb/rustaceanvim"] = {
	lazy = true,
	ft = "rust",
	version = "^3",
	config = require("lang.rust"),
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"lvimuser/lsp-inlayhints.nvim",
			opts = {},
		},
	},
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

lang["lervag/vimtex"] = {
	ft = "tex",
	config = require("lang.vim-tex"),
}

lang["ShinKage/idris2-nvim"] = {
	ft = "idris2",
	config = require("lang.idris"),
	dependencies = { "neovim/nvim-lspconfig", "MunifTanjim/nui.nvim" },
}
lang["xbase-lab/xbase"] = {
	cond = false,
	ft = "swift",
	build = "make install",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"neovim/nvim-lspconfig",
	},
	config = require("lang.xbase"),
}

lang["ashinkarov/nvim-agda"] = {
	ft = "agda",
}

return lang
