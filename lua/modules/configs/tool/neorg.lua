return function()
	require("neorg").setup({
		load = {
			["core.defaults"] = {}, -- Loads default behaviour
			["core.concealer"] = {}, -- Adds pretty icons to your documents
			["core.keybinds"] = {
				config = {
					neorg_leader = "<Leader>o",
				},
			},
			["core.dirman"] = { -- Manages Neorg workspaces
				config = {
					workspaces = {
						default = "~/notes",
					},
					default_workspace = "default",
				},
			},
		},
	})
end
