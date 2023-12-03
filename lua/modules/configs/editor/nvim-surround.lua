return function()
	require("nvim-surround").setup({
		surrounds = {
			["e"] = {
				add = function()
					return { { "==" }, { "==" } }
				end,
			},
		},
	})
end
