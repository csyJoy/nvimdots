return {
	dir = "/Users/csy/Library/Mobile Documents/iCloud~md~obsidian/Documents/knowledge",
	workspaces = {
		{
			name = "knowledge",
			path = "/Users/csy/Library/Mobile Documents/iCloud~md~obsidian/Documents/knowledge",
		},
	},
	disable_frontmatter = true,
	daily_notes = {
		folder = "daily",
		template = "daily-template.md",
	},
	image_name_func = function()
		local year = os.date("%Y")
		local month = os.date("%m")
		local day = os.date("%d")
		local hour = os.date("%H")
		local minute = os.date("%M")
		local second = os.date("%S")
		local filename = string.format("Pasted image %s%s%s%s%s%s.png", year, month, day, hour, minute, second)
		return filename
	end,
	templates = {
		subdir = "template",
	},
	attachments = {
		img_folder = ".",
		img_text_func = function(client, path)
			local link_path
			local vault_relative_path = client:vault_relative_path(path)
			if vault_relative_path ~= nil then
				-- Use relative path if the image is saved in the vault dir.
				link_path = vault_relative_path
			else
				-- Otherwise use the absolute path.
				link_path = tostring(path)
			end
			return string.format("![[%s]]", link_path)
		end,
		confirm_img_paste = false,
	},
	ui = {
		enable = true,
	},
}
