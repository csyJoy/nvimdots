-- =====================================================================
-- 全局变量模块：定义操作系统检测和路径变量
-- =====================================================================
-- 该模块负责检测当前操作系统类型，并设置核心路径变量
-- =====================================================================

local global = {}
local os_name = vim.uv.os_uname().sysname  -- 获取操作系统名称
local realpath = vim.uv.fs_realpath        -- 获取真实路径函数

-- 加载全局变量函数
function global:load_variables()
	-- 操作系统检测
	self.is_mac = os_name == "Darwin"           -- 是否为 macOS
	self.is_linux = os_name == "Linux"          -- 是否为 Linux
	self.is_windows = os_name == "Windows_NT"   -- 是否为 Windows
	self.is_wsl = vim.fn.has("wsl") == 1        -- 是否为 WSL (Windows Subsystem for Linux)

	-- 核心路径配置
	self.vim_path = realpath(vim.fn.stdpath("config"))        -- Neovim 配置目录路径
	self.cache_dir = vim.fn.stdpath("cache")                  -- 缓存目录路径
	self.data_dir = string.format("%s/site/", vim.fn.stdpath("data"))  -- 数据目录路径
	self.modules_dir = self.vim_path .. "/modules"            -- 模块目录路径
	self.home = self.is_windows and vim.env.USERPROFILE or vim.env.HOME  -- 用户主目录路径
end

-- 初始化：加载所有全局变量
global:load_variables()

return global
