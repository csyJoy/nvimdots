return function()
	require("chatgpt").setup({
		chat = {
			keymaps = {
				stop_generating = "<C-b>",
			},
		},
	})
end
