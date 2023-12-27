return function()
	require("chatgpt").setup({
		chat = {
			keymaps = {
				stop_generating = "<C-b>",
				edit_message = "<C-e>",
			},
		},
		openai_params = {
			model = "gpt-4-1106-preview",
			max_tokens = 1500,
		},
		openai_edit_params = {
			model = "gpt-4-1106-preview",
		},
		local_chat_gpt_prompts_path = "/Users/csy/ChatGPT.nvim/foo.csv",
	})
end
