local vim = vim

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.enhance_jk_move = function(key)
	local map = key == "j" and "<Plug>(accelerated_jk_gj)" or "<Plug>(accelerated_jk_gk)"
	return t(map)
end

_G.enhance_ft_move = function(key)
	local map = {
		[";"] = "<Plug>(clever-f-repeat-forward)",
		[","] = "<Plug>(clever-f-repeat-back)",
	}
	return t(map[key])
end

_G.enhance_align = function(key)
	vim.api.nvim_command([[packadd vim-easy-align]])
	local map = { ["nea"] = "<Plug>(EasyAlign)", ["xea"] = "<Plug>(EasyAlign)" }
	return t(map[key])
end

local _lazygit = nil
_G.toggle_lazygit = function()
	if not _lazygit then
		local Terminal = require("toggleterm.terminal").Terminal
		_lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
		})
	end
	_lazygit:toggle()
end

_G.toggle_nvimtree = function()
	local win_list = vim.api.nvim_list_wins()
	if win_list[1] ~= 1000 then
		local first_win_buf_num = vim.api.nvim_win_get_buf(win_list[1])
		local first_win_buf_name = vim.api.nvim_buf_get_name(first_win_buf_num)
		local is_nvimtree = string.find(first_win_buf_name, "NvimTree_1")
		if is_nvimtree ~= nil then
			vim.api.nvim_win_close(win_list[1], true)
		else
			vim.api.nvim_command([[NvimTreeFindFileToggle]])
		end
	else
		vim.api.nvim_command([[NvimTreeFindFileToggle]])
	end
end
