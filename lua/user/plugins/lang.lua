local lang = {}

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

lang["ashinkarov/nvim-agda"] = {
	ft = "agda",
}

return lang
