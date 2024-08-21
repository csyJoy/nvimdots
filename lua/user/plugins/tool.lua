local tool = {}

tool["jackMort/ChatGPT.nvim"] = {
	cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
	config = require("tool.chatgpt"),
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
	config = require("tool.refactoring"),
}

tool["epwalsh/obsidian.nvim"] = {
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
	opts = require("tool.obsidian"),
}

tool["folke/neodev.nvim"] = {
	lazy = true,
	opts = {},
	config = require("tool.neodev"),
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

tool["michaelb/sniprun"] = {
	cond = false,
}

tool["theHamsta/nvim-dap-virtual-text"] = {
	lazy = true,
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == "nvim-dap" then
					require("tool.virtual-text")()
					return true
				end
			end,
		})
	end,
	config = true,
}

tool["amitds1997/remote-nvim.nvim"] = {
	cond = false,
	version = "*", -- Pin to GitHub releases
	dependencies = {
		"nvim-lua/plenary.nvim", -- For standard functions
		"MunifTanjim/nui.nvim", -- To build the plugin UI
		"nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
	},
	config = {
		remote = {
			copy_dirs = {
				config = {
					base = "/Users/csy/.config/nvim-remote",
					dirs = "*",
					compression = {
						enabled = true,
						additional_opts = { "--exclude-vcs" },
					},
				},
				data = {
					base = vim.fn.stdpath("data"), -- Path from where data has to be copied. You can choose to copy entire path or subdirectories inside using `dirs`
					dirs = { "lazy" }, -- Directories inside `base` to copy over. If this is set to string "*"; it means entire `base` should be copied over
					compression = {
						enabled = true, -- Should data be compressed before uploading
						additional_opts = { "--exclude-vcs" }, -- Any arguments that can be passed to `tar` for compression can be specified here to improve your compression
					},
				},
			},
		},
		client_callback = function(port, workspace_config)
			local cmd = ("wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s"):format(
				port,
				("'Remote: %s'"):format(workspace_config.host)
			)
			if vim.env.TERM == "xterm-kitty" then
				cmd = ("kitty -e nvim --server localhost:%s --remote-ui"):format(port)
			end
			vim.fn.jobstart(cmd, {
				detach = true,
				on_exit = function(job_id, exit_code, event_type)
					-- This function will be called when the job exits
					print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
				end,
			})
		end,
	},
}

return tool
