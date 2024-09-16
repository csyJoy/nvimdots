local tool = {}

tool["ThePrimeagen/refactoring.nvim"] = {
	event = "LspAttach",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = require("user.configs.tool.refactoring"),
}

return tool
