return function()
	require("chatgpt").setup({
		chat = {
			keymaps = {
				stop_generating = "<C-b>",
			},
		},
		openai_params = {
			model = "gpt-4-1106-preview",
			max_tokens = 1500,
		},
		openai_edit_params = {
			model = "gpt-4-1106-preview",
		},
	})
end
