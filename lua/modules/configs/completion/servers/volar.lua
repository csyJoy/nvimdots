return function()
	require("lspconfig").volar.setup({
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
	})
end
