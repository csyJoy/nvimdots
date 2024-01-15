return function()
	require("nvim-surround").setup({
		surrounds = {
			["e"] = {
				add = function()
					return { { "==" }, { "==" } }
				end,
			},
			["s"] = {
				add = function()
					return { { "**" }, { "**" } }
				end,
			},
			["c"] = {
				add = function()
					return { { "`" }, { "`" } }
				end,
			},
		},
	})
end
