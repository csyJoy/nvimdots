-- 现在使用 `<A-o>` 或 `<A-1>` 返回 `dotstutor`

---@module 'core.event'
---@description Neovim 事件的自动命令定义
--- 此模块管理各种自动命令以改善编辑器行为:
--- - 自动关闭特殊窗口和文件类型
--- - LSP 附加和配置
--- - 窗口和缓冲区管理
--- - 文件类型特定设置
local autocmd = {}

---@autocmd NvimTreeAutoClose
--- 当 NvimTree 是最后一个窗口时自动关闭
--- 防止 NvimTree 成为唯一剩余的窗口
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("NvimTreeAutoClose", { clear = true }),
	pattern = "NvimTree_*",
	callback = function()
		local layout = vim.api.nvim_call_function("winlayout", {})
		if
			layout[1] == "leaf"
			and vim.bo[vim.api.nvim_win_get_buf(layout[2])].filetype == "NvimTree"
			and layout[3] == nil
		then
			vim.api.nvim_command([[confirm quit]])
		end
	end,
})

---@autocmd AutoCloseWithQ
--- 为某些特殊文件类型映射 'q' 键关闭窗口
--- 适用于 help、quickfix、man 页面、通知和其他工具窗口
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"nofile",
		"terminal",
		"prompt",
		"toggleterm",
		"copilot",
		"startuptime",
		"tsplayground",
		"snacks_terminal",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<Cmd>close<CR>", { silent = true })
	end,
})

---@autocmd LspKeymapLoader
--- 当 LSP 附加到缓冲区时配置 LSP 快捷键和内联提示
--- - 加载 LSP 特定的快捷键绑定
--- - 根据用户设置启用/禁用内联提示
--- - 调试会话期间跳过配置
local mapping = require("keymap.completion")
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspKeymapLoader", { clear = true }),
	callback = function(event)
		if not _G._debugging then
			-- LSP 快捷键
			mapping.lsp(event.buf)

			-- LSP 内联提示
			local inlayhints_enabled = require("core.settings").lsp_inlayhints
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.server_capabilities.inlayHintProvider ~= nil then
				vim.lsp.inlay_hint.enable(inlayhints_enabled == true, { bufnr = event.buf })
			end
		end
	end,
})

---@autocmd RestoreCursorPosition
--- 打开文件时跳转到上次已知的光标位置
--- 使用 '"' 标记将光标恢复到之前的位置
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

---@function nvim_create_augroups
---@param definitions table<string, table> 自动命令组定义的表
--- 从表定义创建多个自动命令组
--- 每个组都添加 '_' 前缀以避免名称冲突
function autocmd.nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		-- 添加下划线前缀以避免名称冲突
		vim.api.nvim_command("augroup _" .. group_name)
		vim.api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.iter({ "autocmd", def }):flatten(math.huge):totable(), " ")
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command("augroup END")
	end
end

---@function load_autocmds
--- 加载所有按类别组织的预定义自动命令
--- 定义会用 'user.event' 中的用户配置进行扩展
function autocmd.load_autocmds()
	local definitions = {
		---@group bufs - 缓冲区相关的自动命令
		bufs = {
			-- 自动重新加载 vim 配置
			{
				"BufWritePost",
				[[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]],
			},
			-- 如果设置了 setlocal autoread，自动重新加载 Vim 脚本
			{
				"BufWritePost,FileWritePost",
				"*.vim",
				[[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
			},
			{ "BufWritePre", "*~", "setlocal noundofile" },
			{ "BufWritePre", "/tmp/*", "setlocal noundofile" },
			{ "BufWritePre", "*.tmp", "setlocal noundofile" },
			{ "BufWritePre", "*.bak", "setlocal noundofile" },
			{ "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
			{ "BufWritePre", "description", "setlocal noundofile" },
			{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
			-- 自动切换目录
			-- { "BufEnter", "*", "silent! lcd %:p:h" },
			-- 自动切换 fcitx5
			-- {"InsertLeave", "* :silent", "!fcitx5-remote -c"},
			-- {"BufCreate", "*", ":silent !fcitx5-remote -c"},
			-- {"BufEnter", "*", ":silent !fcitx5-remote -c "},
			-- {"BufLeave", "*", ":silent !fcitx5-remote -c "}
		},
		---@group wins - 窗口相关的自动命令
		wins = {
			-- 仅在聚焦窗口中高亮当前行
			{
				"WinEnter,BufEnter,InsertLeave",
				"*",
				[[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
			},
			{
				"WinLeave,BufLeave,InsertEnter",
				"*",
				[[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
			},
			-- 离开 nvim 时尝试写入 shada
			{
				"VimLeave",
				"*",
				[[if has('nvim') | wshada | else | wviminfo! | endif]],
			},
			-- 窗口获得焦点时检查文件是否更改，比 'autoread' 更主动
			{ "FocusGained", "*", "checktime" },
			-- 调整 Vim 窗口大小时保持统一的窗口尺寸
			{ "VimResized", "*", [[tabdo wincmd =]] },
		},
		---@group ft - 文件类型特定的自动命令
		ft = {
			{ "FileType", "*", "setlocal formatoptions-=cro" },
			{ "FileType", "alpha", "setlocal showtabline=0" },
			{ "FileType", "markdown", "setlocal wrap" },
			{ "FileType", "dap-repl", "lua require('dap.ext.autocompl').attach()" },
			{
				"FileType",
				"c,cpp",
				"nnoremap <silent> <buffer> <leader>h <Cmd>ClangdSwitchSourceHeader<CR>",
			},
		},
		---@group yank - 复制相关的自动命令
		yank = {
			{
				"TextYankPost",
				"*",
				[[silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 300 })]],
			},
		},
	}

	autocmd.nvim_create_augroups(require("modules.utils").extend_config(definitions, "user.event"))
end

-- 初始化所有自动命令
autocmd.load_autocmds()
