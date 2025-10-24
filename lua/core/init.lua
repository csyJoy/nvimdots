-- =====================================================================
-- 核心初始化模块：Neovim 启动和初始化流程
-- =====================================================================
-- 本文件负责：
-- - 创建必要的缓存和数据目录
-- - 配置 Leader 键
-- - 设置 GUI 客户端选项
-- - 配置剪贴板集成
-- - 设置 Shell 环境
-- - 加载所有核心模块
-- =====================================================================

local settings = require("core.settings")
local global = require("core.global")

-- ========== 目录创建 ==========
-- Create cache dir and data dirs
-- 创建缓存目录和数据目录
local createdir = function()
	local data_dirs = {
		global.cache_dir .. "/backup",   -- 备份文件目录
		global.cache_dir .. "/session",  -- 会话文件目录
		global.cache_dir .. "/swap",     -- 交换文件目录
		global.cache_dir .. "/tags",     -- 标签文件目录
		global.cache_dir .. "/undo",     -- 撤销历史目录
	}
	-- Only check whether cache_dir exists, this would be enough.
	-- 只需检查缓存目录是否存在
	if vim.fn.isdirectory(global.cache_dir) == 0 then
		---@diagnostic disable-next-line: param-type-mismatch
		vim.fn.mkdir(global.cache_dir, "p")
		for _, dir in pairs(data_dirs) do
			if vim.fn.isdirectory(dir) == 0 then
				vim.fn.mkdir(dir, "p")
			end
		end
	end
end

-- ========== Leader 键配置 ==========
-- 设置 Leader 键为空格键
local leader_map = function()
	vim.g.mapleader = " "
	-- NOTE:
	--  > Uncomment the following if you're using a <leader> other than <Space>, and you wish
	--  > to disable advancing one character by pressing <Space> in normal/visual mode.
	--  > 如果使用非空格的 Leader 键，并希望禁用空格键在普通/可视模式下前进一个字符的功能，
	--  > 请取消下面两行的注释
	-- vim.api.nvim_set_keymap("n", " ", "", { noremap = true })
	-- vim.api.nvim_set_keymap("x", " ", "", { noremap = true })
end

-- ========== GUI 配置 ==========
-- 配置 GUI 客户端的字体设置
local gui_config = function()
	if next(settings.gui_config) then
		vim.api.nvim_set_option_value(
			"guifont",
			settings.gui_config.font_name .. ":h" .. settings.gui_config.font_size,
			{}
		)
	end
end

-- ========== Neovide 配置 ==========
-- 配置 Neovide 特定选项
local neovide_config = function()
	for name, config in pairs(settings.neovide_config) do
		vim.g["neovide_" .. name] = config
	end
end

-- ========== 剪贴板配置 ==========
-- 配置系统剪贴板集成（macOS 和 WSL）
local clipboard_config = function()
	if global.is_mac then
		-- macOS 剪贴板配置
		vim.g.clipboard = {
			name = "macOS-clipboard",
			copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
			paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
			cache_enabled = 0,
		}
	elseif global.is_wsl then
		-- WSL (Windows Subsystem for Linux) 剪贴板配置
		vim.g.clipboard = {
			name = "win32yank-wsl",
			copy = {
				["+"] = "win32yank.exe -i --crlf",
				["*"] = "win32yank.exe -i --crlf",
			},
			paste = {
				["+"] = "win32yank.exe -o --lf",
				["*"] = "win32yank.exe -o --lf",
			},
			cache_enabled = 0,
		}
	end
end

-- ========== Shell 配置 ==========
-- 配置 Windows 下的 PowerShell 环境
local shell_config = function()
	if global.is_windows then
		-- 检查 PowerShell 是否可用
		if not (vim.fn.executable("pwsh") == 1 or vim.fn.executable("powershell") == 1) then
			vim.notify(
				[[
Failed to setup terminal config

PowerShell is either not installed, missing from PATH, or not executable;
cmd.exe will be used instead for `:!` (shell bang) and toggleterm.nvim.

You're recommended to install PowerShell for better experience.]],
				vim.log.levels.WARN,
				{ title = "[core] Runtime Warning" }
			)
			return
		end

		-- 配置 PowerShell 选项
		local basecmd = "-NoLogo -MTA -ExecutionPolicy RemoteSigned"
		local ctrlcmd = "-Command [console]::InputEncoding = [console]::OutputEncoding = [System.Text.Encoding]::UTF8"
		local set_opts = vim.api.nvim_set_option_value
		set_opts("shell", vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell", {})
		set_opts("shellcmdflag", string.format("%s %s;", basecmd, ctrlcmd), {})
		set_opts("shellredir", "-RedirectStandardOutput %s -NoNewWindow -Wait", {})
		set_opts("shellpipe", "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode", {})
		set_opts("shellquote", "", {})
		set_opts("shellxquote", "", {})
	end
end

-- ========== 核心加载 ==========
-- 加载所有核心组件
local load_core = function()
	-- 1. 创建必要目录
	createdir()
	-- 2. 设置 Leader 键
	leader_map()

	-- 3. 应用 GUI 配置
	gui_config()
	neovide_config()
	clipboard_config()
	shell_config()

	-- 4. 加载核心模块
	require("core.options")    -- Neovim 选项配置
	require("core.event")      -- 自动命令事件
	require("core.pack")       -- 插件管理器
	require("keymap")          -- 快捷键映射

	-- 5. 设置文件编码支持（支持中文等多种编码）
	vim.opt.fileencodings =
		"utf-8,gbk,gb2312,gb18030,big5,euc-jp,ucs-bom,utf-16,utf-16le,utf-16be,utf-32,utf-32le,utf-32be"

	-- 6. 应用主题配置
	vim.api.nvim_set_option_value("background", settings.background, {})
	vim.cmd.colorscheme(settings.colorscheme)
end

-- 执行核心初始化
load_core()
