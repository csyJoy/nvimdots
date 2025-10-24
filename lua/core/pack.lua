-- =====================================================================
-- 插件管理器模块：Lazy.nvim 引导和配置
-- =====================================================================
-- 本文件负责：
-- - 自动安装 lazy.nvim 插件管理器
-- - 加载插件规格列表（modules/plugins/*.lua）
-- - 合并用户自定义插件（user/plugins/*.lua）
-- - 配置 lazy.nvim 的 UI、性能和行为
-- - 管理禁用的插件和运行时路径优化
-- =====================================================================

local fn, api = vim.fn, vim.api
local global = require("core.global")
local is_mac = global.is_mac -- macOS 标识
local vim_path = global.vim_path -- Neovim 配置目录
local data_dir = global.data_dir -- 数据目录
local lazy_path = data_dir .. "lazy/lazy.nvim" -- lazy.nvim 安装路径
local modules_dir = vim_path .. "/lua/modules" -- 模块目录
local user_config_dir = vim_path .. "/lua/user" -- 用户配置目录

local settings = require("core.settings")
local use_ssh = settings.use_ssh -- 是否使用 SSH 克隆插件

-- 加载图标集合（用于 lazy.nvim UI）
local icons = {
	kind = require("modules.utils.icons").get("kind"),
	documents = require("modules.utils.icons").get("documents"),
	ui = require("modules.utils.icons").get("ui"),
	ui_sep = require("modules.utils.icons").get("ui", true),
	misc = require("modules.utils.icons").get("misc"),
}

-- Lazy 插件管理器类
local Lazy = {}

-- ========== 插件加载函数 ==========
-- 从 modules/plugins/*.lua 和 user/plugins/*.lua 加载所有插件规格
function Lazy:load_plugins()
	self.modules = {}

	-- 将自定义配置路径添加到 Lua 包搜索路径
	local append_nativertp = function()
		package.path = package.path
			.. string.format(
				";%s;%s;%s;%s",
				user_config_dir .. "/configs/?.lua", -- 用户配置文件
				modules_dir .. "/configs/?.lua", -- 模块配置文件
				modules_dir .. "/configs/?/init.lua", -- 模块配置目录
				user_config_dir .. "/?.lua" -- 用户根目录文件
			)
	end

	-- 获取所有插件规格文件列表
	local get_plugins_list = function()
		local list = {}
		-- 获取模块插件列表（completion, editor, lang, tool, ui）
		local plugins_list = vim.split(fn.glob(modules_dir .. "/plugins/*.lua"), "\n")
		-- 获取用户自定义插件列表
		local user_plugins_list = vim.split(fn.glob(user_config_dir .. "/plugins/*.lua"), "\n", { trimempty = true })
		-- 合并两个列表
		vim.list_extend(plugins_list, user_plugins_list)
		for _, f in ipairs(plugins_list) do
			-- 将完整路径转换为模块名（用于 require）
			-- 例如：/path/to/modules/plugins/completion.lua -> modules.plugins.completion
			list[#list + 1] = f:find(modules_dir) and f:sub(#modules_dir - 6, -1) or f:sub(#user_config_dir - 3, -1)
		end
		return list
	end

	-- 添加自定义路径到 Lua 搜索路径
	append_nativertp()

	-- 加载所有插件规格
	for _, m in ipairs(get_plugins_list()) do
		-- require 插件规格模块
		local modules = require(m:sub(0, #m - 4))
		if type(modules) == "table" then
			-- 将每个插件添加到模块列表中
			for name, conf in pairs(modules) do
				self.modules[#self.modules + 1] = vim.tbl_extend("force", { name }, conf)
			end
		end
	end
	-- 添加禁用的插件到列表
	for _, name in ipairs(settings.disabled_plugins) do
		self.modules[#self.modules + 1] = { name, enabled = false }
	end
end

-- ========== Lazy.nvim 引导和初始化函数 ==========
-- 自动安装 lazy.nvim 并配置插件管理器
function Lazy:load_lazy()
	-- 检查 lazy.nvim 是否已安装，如果未安装则自动克隆
	if not vim.uv.fs_stat(lazy_path) then
		local lazy_repo = use_ssh and "git@github.com:folke/lazy.nvim.git " or "https://github.com/folke/lazy.nvim.git "
		api.nvim_command("!git clone --filter=blob:none --branch=stable " .. lazy_repo .. lazy_path)
	end
	-- 加载所有插件规格
	self:load_plugins()

	-- 设置插件克隆地址格式（SSH 或 HTTPS）
	local clone_prefix = use_ssh and "git@github.com:%s.git" or "https://github.com/%s.git"

	-- ========== Lazy.nvim 配置 ==========
	local lazy_settings = {
		-- 插件安装目录
		root = data_dir .. "lazy",

		-- Git 配置
		git = {
			timeout = 300, -- 克隆超时时间（秒）
			url_format = clone_prefix, -- 仓库 URL 格式
		},

		-- 安装配置
		install = {
			-- 启动时自动安装缺失的插件（不会增加启动时间）
			missing = true,
			colorscheme = { settings.colorscheme }, -- 安装时使用的配色方案
		},

		-- UI 界面配置
		ui = {
			-- 窗口大小（<1 为百分比，>1 为固定大小）
			size = { width = 0.88, height = 0.8 },
			wrap = true, -- 自动换行
			border = "rounded", -- 窗口边框样式

			-- 图标配置
			icons = {
				cmd = icons.misc.Code, -- 命令图标
				config = icons.ui.Gear, -- 配置图标
				event = icons.kind.Event, -- 事件图标
				ft = icons.documents.Files, -- 文件类型图标
				init = icons.misc.ManUp, -- 初始化图标
				import = icons.documents.Import, -- 导入图标
				keys = icons.ui.Keyboard, -- 快捷键图标
				loaded = icons.ui.Check, -- 已加载图标
				not_loaded = icons.misc.Ghost, -- 未加载图标
				plugin = icons.ui.Package, -- 插件图标
				runtime = icons.misc.Vim, -- 运行时图标
				source = icons.kind.StaticMethod, -- 源代码图标
				start = icons.ui.Play, -- 启动图标
				list = {
					icons.ui_sep.BigCircle, -- 列表分隔符
					icons.ui_sep.BigUnfilledCircle,
					icons.ui_sep.Square,
					icons.ui_sep.ChevronRight,
				},
			},
		},

		-- 性能优化配置
		performance = {
			-- 缓存配置
			cache = {
				enabled = true,
				path = vim.fn.stdpath("cache") .. "/lazy/cache",
				-- 以下事件触发时将禁用缓存
				-- 设置为 {} 可缓存所有模块（不推荐）
				disable_events = { "UIEnter", "BufReadPre" },
				ttl = 3600 * 24 * 2, -- 保留未使用模块的缓存时间（2天）
			},
			-- 重置包路径以提高启动速度
			reset_packpath = true,

			-- 运行时路径配置
			rtp = {
				reset = true, -- 重置运行时路径为 $VIMRUNTIME 和配置目录
				---@type string[]
				paths = {}, -- 在此添加需要包含在 rtp 中的自定义路径

				-- 禁用的内置插件（提高性能）
				disabled_plugins = {
					-- 取消 "editorconfig" 注释以启用原生 EditorConfig 支持
					-- 警告：Sleuth.vim 已包含此插件的所有功能
					--       不要同时启用两者，否则可能破坏整个检测系统
					"editorconfig",
					-- 不加载拼写文件
					"spellfile",
					-- 不使用内置的 matchit.vim 和 matchparen.vim（使用 vim-matchup 替代）
					"matchit",
					"matchparen",
					-- 不加载 tohtml.vim
					"tohtml",
					-- 不加载压缩文件插件（zipPlugin, gzip, tarPlugin）
					"gzip",
					"tarPlugin",
					"zipPlugin",
					-- 禁用远程插件
					-- 注意：
					--  > 禁用 rplugin.vim 会导致 wilder.nvim 在 :checkhealth 时报错
					--  > 但由于其配置不严格需要 Python rtp，可以暂时忽略
					-- "rplugin",
				},
			},
		},
	}

	-- macOS 特定配置：增加并发下载数
	if is_mac then
		lazy_settings.concurrency = 20
	end

	-- 将 lazy.nvim 添加到运行时路径
	vim.opt.rtp:prepend(lazy_path)
	-- 初始化 lazy.nvim 并加载所有插件
	require("lazy").setup(self.modules, lazy_settings)
end

-- 执行 Lazy.nvim 初始化
Lazy:load_lazy()
