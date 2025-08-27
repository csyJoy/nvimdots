local tool = {}

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

tool["folke/lazydev.nvim"] = {
	ft = "lua", -- only load on lua files
	opts = {
		library = {
			-- See the configuration section for more details
			-- Load luvit types when the `vim.uv` word is found
			"lazy.nvim",
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
			"LazyVim",
			{ path = "wezterm-types", mods = { "wezterm" } },
		},
	},
}

tool["Bilal2453/luvit-meta"] = {
	lazy = true,
}

tool["justinsgithub/wezterm-types"] = {
	lazy = true,
}

tool["mrjones2014/smart-splits.nvim"] = {}

tool["demo"] = {
	cmd = "GenerateFlashcards",
	dir = "/Users/csy/demo.nvim",
	dependencies = {
		"epwalsh/obsidian.nvim",
	},
}

tool["CopilotC-Nvim/CopilotChat.nvim"] = {
	branch = "main",
	dependencies = {
		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	},
	build = "make tiktoken", -- Only on MacOS or Linux
	opts = {
		debug = false, -- Enable debugging
		-- See Configuration section for rest
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

tool["coder/claudecode.nvim"] = {
	dependencies = { "folke/snacks.nvim" },
	opts = {
		terminal_cmd = "claude",
	},
	config = true,
	keys = {
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
		},
		-- Diff management
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}

return tool
