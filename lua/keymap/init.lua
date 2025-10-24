-- =====================================================================
-- 快捷键配置主入口：加载和初始化所有快捷键映射
-- =====================================================================
-- 本文件负责：
-- - 加载快捷键辅助函数和绑定工具
-- - 定义插件管理器（lazy.nvim）的核心快捷键
-- - 加载各分类模块的快捷键（completion, editor, lang, tool, ui）
-- - 加载用户自定义快捷键覆盖
-- =====================================================================

-- 加载快捷键辅助函数
require("keymap.helpers")

-- 加载快捷键绑定工具类（builder 模式）
local bind = require("keymap.bind")
local map_cr = bind.map_cr

-- ========== 核心快捷键映射 ==========
-- 插件管理器（lazy.nvim）相关快捷键
local mappings = {
	core = {
		-- 包管理器命令
		["n|<leader>ph"] = map_cr("Lazy"):with_silent():with_noremap():with_nowait():with_desc("package: Show"),
		["n|<leader>ps"] = map_cr("Lazy sync"):with_silent():with_noremap():with_nowait():with_desc("package: Sync"),
		["n|<leader>pu"] = map_cr("Lazy update")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("package: Update"),
		["n|<leader>pi"] = map_cr("Lazy install")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("package: Install"),
		["n|<leader>pl"] = map_cr("Lazy log"):with_silent():with_noremap():with_nowait():with_desc("package: Log"),
		["n|<leader>pc"] = map_cr("Lazy check"):with_silent():with_noremap():with_nowait():with_desc("package: Check"),
		["n|<leader>pd"] = map_cr("Lazy debug"):with_silent():with_noremap():with_nowait():with_desc("package: Debug"),
		["n|<leader>pp"] = map_cr("Lazy profile")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("package: Profile"),
		["n|<leader>pr"] = map_cr("Lazy restore")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("package: Restore"),
		["n|<leader>px"] = map_cr("Lazy clean"):with_silent():with_noremap():with_nowait():with_desc("package: Clean"),
	},
}

-- 加载核心快捷键
bind.nvim_load_mapping(mappings.core)

-- ========== 加载分类快捷键模块 ==========
-- 这些模块包含各功能分类的快捷键定义
require("keymap.completion")  -- LSP 和补全相关快捷键
require("keymap.editor")      -- 编辑器增强功能快捷键
require("keymap.lang")        -- 语言特定功能快捷键
require("keymap.tool")        -- 开发工具快捷键
require("keymap.ui")          -- UI 和界面快捷键

-- ========== 加载用户自定义快捷键 ==========
-- 用户可以通过 user/keymap/init.lua 覆盖或添加新的快捷键
local ok, def = pcall(require, "user.keymap.init")
if ok then
	require("modules.utils.keymap").replace(def)
end
