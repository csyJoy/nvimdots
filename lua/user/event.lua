vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.spell = true
	end,
})

local definitions = {
	-- Example
	bufs = {
		{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
	},
}

vim.api.nvim_create_autocmd(
	{ "FocusLost", "ModeChanged", "TextChanged", "BufEnter" },
	{ desc = "autosave", pattern = "*", command = "silent! update" }
)

return definitions
