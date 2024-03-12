return function()
	vim.g.rustaceanvim = {
		-- Disable automatic DAP configuration to avoid conflicts with previous user configs
		dap = {
			adapter = false,
			configuration = false,
			autoload_configurations = false,
		},
		inlay_hints = {
			highlight = "NonText",
		},
		tools = {
			hover_actions = {
				auto_focus = true,
			},
		},
		server = {
			on_attach = function(client, bufnr)
				require("lsp-inlayhints").on_attach(client, bufnr)
			end,
		},
	}
	require("modules.utils").load_plugin("rustaceanvim", nil, true)
end
