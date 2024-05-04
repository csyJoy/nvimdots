local tool = {}

tool["jackMort/ChatGPT.nvim"] = {
	dir = "/Users/csy/ChatGPT.nvim",
	cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
	config = require("user.configs.tool.chatgpt"),
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
}

tool["ThePrimeagen/refactoring.nvim"] = {
	event = "LspAttach",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = require("user.configs.tool.refactoring"),
}

tool["epwalsh/obsidian.nvim"] = {
	dir = "/Users/csy/obsidian.nvim/",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	cmd = {
		"ObsidianSearch",
		"ObsidianOpen",
		"ObsidianNew",
		"ObsidianQuickSwitch",
		"ObsidianFollowLink",
		"ObsidianBacklinks",
		"ObsidianToday",
		"ObsidianYesterday",
		"ObsidianTomorrow",
		"ObsidianTemplate",
		"ObsidianLink",
		"ObsidianLinkNew",
		"ObsidianWorkspace",
		"ObsidianPasteImg",
	},
	-- ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	--   "BufReadPre path/to/my-vault/**.md",
	--   "BufNewFile path/to/my-vault/**.md",
	-- },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = require("user.configs.tool.obsidian"),
}

tool["folke/neodev.nvim"] = {
	lazy = true,
	opts = {},
	config = require("user.configs.tool.neodev"),
}

tool["mrjones2014/smart-splits.nvim"] = {}

tool["demo"] = {
	cmd = "GenerateFlashcards",
	dir = "/Users/csy/demo.nvim",
	dependencies = {
		"epwalsh/obsidian.nvim",
	},
}

tool["jellydn/CopilotChat.nvim"] = {
	opts = {
		mode = "split", -- newbuffer or split  , default: newbuffer
	},
	build = function()
		vim.defer_fn(function()
			vim.cmd("UpdateRemotePlugins")
			vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
		end, 3000)
	end,
	event = "VeryLazy",
	keys = {
		{ "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
		{ "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
	},
}

return tool
