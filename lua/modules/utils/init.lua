-- =====================================================================
-- 工具函数模块：提供通用的辅助函数和工具
-- =====================================================================
-- 本文件提供：
-- - 调色板管理（palette）和颜色工具函数
-- - 高亮组（highlight groups）生成和管理
-- - 颜色混合函数（blend, darken, lighten）
-- - LSP 服务器注册函数
-- - 配置扩展和合并工具
-- - 插件加载框架
-- =====================================================================

local M = {}

-- ========== 调色板类型定义 ==========
-- Catppuccin 风格的调色板，包含所有主题颜色
---@class palette
---@field rosewater string 玫瑰水色
---@field flamingo string 火烈鸟色
---@field mauve string 紫红色
---@field pink string 粉红色
---@field red string 红色
---@field maroon string 栗色
---@field peach string 桃色
---@field yellow string 黄色
---@field green string 绿色
---@field sapphire string 蓝宝石色
---@field blue string 蓝色
---@field sky string 天空蓝
---@field teal string 青色
---@field lavender string 薰衣草色
---@field text string 文本色
---@field subtext1 string 次级文本色 1
---@field subtext0 string 次级文本色 0
---@field overlay2 string 覆盖层颜色 2
---@field overlay1 string 覆盖层颜色 1
---@field overlay0 string 覆盖层颜色 0
---@field surface2 string 表面颜色 2
---@field surface1 string 表面颜色 1
---@field surface0 string 表面颜色 0
---@field base string 基础背景色
---@field mantle string 覆盖背景色
---@field crust string 外壳背景色
---@field none "NONE" 无颜色（透明）

---@type nil|palette
local palette = nil

-- 标记是否已注册调色板刷新的自动命令
---@type boolean
local _has_autocmd = false

-- ========== 调色板初始化 ==========
-- 初始化全局调色板，并在配色方案改变时自动刷新
---@return palette 返回当前调色板
local function init_palette()
	-- 在配色方案改变时重新初始化调色板
	if not _has_autocmd then
		_has_autocmd = true
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("__builtin_palette", { clear = true }),
			pattern = "*",
			callback = function()
				palette = nil
				init_palette()
				-- 同时刷新硬编码的高亮组
				M.gen_alpha_hl()
				M.gen_lspkind_hl()
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end

	if not palette then
		-- 如果使用 catppuccin 主题，从插件获取调色板
		-- 否则使用默认调色板
		palette = (vim.g.colors_name or ""):find("catppuccin") and require("catppuccin.palettes").get_palette()
			or {
				rosewater = "#DC8A78",
				flamingo = "#DD7878",
				mauve = "#CBA6F7",
				pink = "#F5C2E7",
				red = "#E95678",
				maroon = "#B33076",
				peach = "#FF8700",
				yellow = "#F7BB3B",
				green = "#AFD700",
				sapphire = "#36D0E0",
				blue = "#61AFEF",
				sky = "#04A5E5",
				teal = "#B5E8E0",
				lavender = "#7287FD",

				text = "#F2F2BF",
				subtext1 = "#BAC2DE",
				subtext0 = "#A6ADC8",
				overlay2 = "#C3BAC6",
				overlay1 = "#988BA2",
				overlay0 = "#6E6B6B",
				surface2 = "#6E6C7E",
				surface1 = "#575268",
				surface0 = "#302D41",

				base = "#1D1536",
				mantle = "#1C1C19",
				crust = "#161320",
			}

		-- 合并用户自定义的调色板覆盖
		palette = vim.tbl_extend("force", { none = "NONE" }, palette, require("core.settings").palette_overwrite)
	end

	return palette
end

-- ========== 颜色转换和混合函数 ==========

-- 将十六进制颜色转换为 RGB 数组
---@param c string 十六进制颜色值（如 "#RRGGBB"）
---@return number[] RGB 数组 {R, G, B}
local function hex_to_rgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

-- 设置全局高亮组
-- 注意：如果当前主题不是 catppuccin，此函数不会覆盖已有定义
---@param name string 高亮组名称（如 "ErrorMsg"）
---@param foreground? string 前景色
---@param background? string 背景色
---@param italic? boolean 是否斜体
local function set_global_hl(name, foreground, background, italic)
	vim.api.nvim_set_hl(0, name, {
		fg = foreground,
		bg = background,
		italic = italic == true,
		default = not vim.g.colors_name:find("catppuccin"),
	})
end

-- 混合前景色和背景色
-- 根据 alpha 值（透明度）混合两个颜色
---@param foreground string 前景色（十六进制）
---@param background string 背景色（十六进制）
---@param alpha number|string 混合程度（0-1 之间的数字）
---@return string 混合后的十六进制颜色值
function M.blend(foreground, background, alpha)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = hex_to_rgb(background)
	local fg = hex_to_rgb(foreground)

	-- 混合单个颜色通道（R、G 或 B）
	local blend_channel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", blend_channel(1), blend_channel(2), blend_channel(3))
end

-- 使颜色变暗
-- 通过与背景色混合来降低颜色亮度
---@param hex string 要变暗的十六进制颜色
---@param amount number 变暗程度（0-1）
---@param bg string 用于混合的背景色（默认为黑色）
---@return string 变暗后的十六进制颜色值
function M.darken(hex, amount, bg)
	return M.blend(hex, bg or "#000000", math.abs(amount))
end

-- 使颜色变亮
-- 通过与前景色混合来提高颜色亮度
---@param hex string 要变亮的十六进制颜色
---@param amount number 变亮程度（0-1）
---@param fg string 用于混合的前景色（默认为白色）
---@return string 变亮后的十六进制颜色值
function M.lighten(hex, amount, fg)
	return M.blend(hex, fg or "#FFFFFF", math.abs(amount))
end

-- 从高亮组获取 RGB 颜色值
---@param hl_group string 高亮组名称
---@param use_bg boolean 返回背景色还是前景色
---@param fallback_hl? string 当高亮组不存在时的备用值
---@return string 十六进制颜色值
function M.hl_to_rgb(hl_group, use_bg, fallback_hl)
	local hex = fallback_hl or "#000000"
	local hlexists = pcall(vim.api.nvim_get_hl, 0, { name = hl_group, link = false })

	if hlexists then
		local result = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
		if use_bg then
			hex = result.bg and string.format("#%06x", result.bg) or "NONE"
		else
			hex = result.fg and string.format("#%06x", result.fg) or "NONE"
		end
	end

	return hex
end

-- 扩展高亮组
-- 在现有高亮组的基础上添加或修改属性
---@param name string 目标高亮组名称
---@param def table 要扩展的属性
function M.extend_hl(name, def)
	local hlexists = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if not hlexists then
		-- 高亮组不存在时什么都不做
		return
	end
	local current_def = vim.api.nvim_get_hl(0, { name = name, link = false })
	local combined_def = vim.tbl_deep_extend("force", current_def, def)

	---@diagnostic disable-next-line: param-type-mismatch
	vim.api.nvim_set_hl(0, name, combined_def)
end

-- ========== 调色板获取函数 ==========
-- 获取调色板（支持颜色覆盖）
---@param overwrite palette? 要覆盖的颜色（最高优先级）
---@return palette 返回调色板
function M.get_palette(overwrite)
	if not overwrite then
		return vim.deepcopy(init_palette(), true)
	else
		return vim.tbl_extend("force", init_palette(), overwrite)
	end
end

-- ========== 高亮组生成函数 ==========

-- 为 lspsaga 生成高亮组
-- 已有属性不会被覆盖
function M.gen_lspkind_hl()
	local colors = M.get_palette()
	-- LSP 符号类型对应的颜色映射
	local dat = {
		Class = colors.yellow,
		Constant = colors.peach,
		Constructor = colors.sapphire,
		Enum = colors.yellow,
		EnumMember = colors.teal,
		Event = colors.yellow,
		Field = colors.teal,
		File = colors.rosewater,
		Function = colors.blue,
		Interface = colors.yellow,
		Key = colors.red,
		Method = colors.blue,
		Module = colors.blue,
		Namespace = colors.blue,
		Number = colors.peach,
		Operator = colors.sky,
		Package = colors.blue,
		Property = colors.teal,
		Struct = colors.yellow,
		TypeParameter = colors.blue,
		Variable = colors.peach,
		Array = colors.peach,
		Boolean = colors.peach,
		Null = colors.yellow,
		Object = colors.yellow,
		String = colors.green,
		TypeAlias = colors.green,
		Parameter = colors.blue,
		StaticMethod = colors.peach,
		Text = colors.green,
		Snippet = colors.mauve,
		Folder = colors.blue,
		Unit = colors.green,
		Value = colors.peach,
	}

	-- 为每种 LSP 符号类型设置高亮组
	for kind, color in pairs(dat) do
		set_global_hl("LspKind" .. kind, color)
	end
end

-- 为 alpha 启动页生成高亮组
-- 已有属性不会被覆盖
function M.gen_alpha_hl()
	local colors = M.get_palette()

	set_global_hl("AlphaHeader", colors.blue)
	set_global_hl("AlphaButtons", colors.green)
	set_global_hl("AlphaShortcut", colors.pink, nil, true)
	set_global_hl("AlphaFooter", colors.yellow)
end

-- 为 cursorword 生成高亮组
-- 已有属性不会被覆盖
function M.gen_cursorword_hl()
	local colors = M.get_palette()

	-- 不高亮当前光标下的单词
	set_global_hl("MiniCursorword", nil, M.darken(colors.surface1, 0.7, colors.base))
	set_global_hl("MiniCursorwordCurrent", nil)
end

-- ========== LSP 服务器注册 ==========
-- 一次性设置并启用语言服务器
---@param server string 语言服务器名称
---@param config? vim.lsp.Config 可选的配置
function M.register_server(server, config)
	vim.validate("server", server, "string", false)
	vim.validate("config", config, "table", true)

	if config then
		vim.lsp.config(server, config)
	end
	vim.lsp.enable(server)
end

-- ========== 工具函数 ==========
-- 将数字（0/1）转换为布尔值
---@param value number 要检查的值
---@return boolean|nil 转换失败时返回 nil
function M.tobool(value)
	if value == 0 then
		return false
	elseif value == 1 then
		return true
	else
		vim.notify(
			"Attempting to convert data of type '" .. type(value) .. "' [other than 0 or 1] to boolean",
			vim.log.levels.ERROR,
			{ title = "[utils] Runtime Error" }
		)
		return nil
	end
end

-- ========== 配置扩展函数 ==========

-- 递归合并表
-- 与 vim.tbl_deep_extend() 不同，此函数会扩展原始值为列表的情况
---@param dst table 将被修改和追加的目标表
---@param src table 要插入值的源表
---@return table 修改后的表
local function tbl_recursive_merge(dst, src)
	for key, value in pairs(src) do
		if type(dst[key]) == "table" and type(value) == "function" then
			-- 如果源值是函数，调用它并传入目标值
			dst[key] = value(dst[key])
		elseif type(dst[key]) == "table" and vim.islist(dst[key]) and key ~= "dashboard_image" then
			-- 如果是列表类型（除了 dashboard_image），扩展列表
			vim.list_extend(dst[key], value)
		elseif type(dst[key]) == "table" and type(value) == "table" and not vim.islist(dst[key]) then
			-- 如果都是表（非列表），递归合并
			tbl_recursive_merge(dst[key], value)
		else
			-- 其他情况直接覆盖
			dst[key] = value
		end
	end
	return dst
end

-- 扩展现有的核心配置（settings, events 等）
---@param config table 要合并的默认配置
---@param user_config string 用于 require 用户配置的模块名
---@return table 扩展后的配置
function M.extend_config(config, user_config)
	local ok, extras = pcall(require, user_config)
	if ok and type(extras) == "table" then
		config = tbl_recursive_merge(config, extras)
	end
	return config
end

-- ========== 插件加载框架 ==========
-- 加载插件并整合用户自定义配置
-- 支持 Lua 插件和 Vimscript 插件的不同加载方式
--
-- 工作流程：
--   1. 尝试加载用户配置（user/configs/{plugin}.lua）
--   2. 根据插件类型和用户配置类型决定加载方式
--   3. 对于 Lua 插件：合并或替换默认配置
--   4. 对于 Vimscript 插件：执行用户提供的函数
--
---@param plugin_name string 插件的模块名（用于调用 setup）
---@param opts nil|table 要合并的默认配置
---@param vim_plugin? boolean 此插件是否用 Vimscript 编写
---@param setup_callback? function 如果插件需要特殊的 setup 函数，添加新回调
function M.load_plugin(plugin_name, opts, vim_plugin, setup_callback)
	vim_plugin = vim_plugin or false

	-- 获取默认配置的文件名
	local fname = debug.getinfo(2, "S").source:match("[^@/\\]*.lua$")
	-- 尝试加载用户配置
	local ok, user_config = pcall(require, "user.configs." .. fname:sub(0, #fname - 4))

	-- ========== Vimscript 插件处理 ==========
	if ok and vim_plugin then
		if user_config == false then
			-- 用户明确要求禁用插件设置时提前返回
			return
		elseif type(user_config) == "function" then
			-- 按用户指定的方式设置
			user_config()
		else
			vim.notify(
				string.format(
					"<%s> is not a typical Lua plugin, please return a function with\nthe corresponding options defined instead (usually via `vim.g.*`)",
					plugin_name
				),
				vim.log.levels.ERROR,
				{ title = "[utils] Runtime Error (User Config)" }
			)
		end

	-- ========== Lua 插件处理 ==========
	elseif not vim_plugin then
		if user_config == false then
			-- 用户明确要求禁用插件设置时提前返回
			return
		else
			-- 使用插件的 setup 函数或自定义回调
			setup_callback = setup_callback or require(plugin_name).setup

			-- 用户配置存在？
			if ok then
				-- 如果用户配置是表，扩展基础配置
				if type(user_config) == "table" then
					opts = tbl_recursive_merge(opts, user_config)
					setup_callback(opts)

				-- 如果用户配置是函数，替换基础配置
				elseif type(user_config) == "function" then
					local user_opts = user_config(opts)
					if type(user_opts) == "table" then
						setup_callback(user_opts)
					end
				else
					vim.notify(
						string.format(
							[[
Please return a `table` if you want to override some of the default options OR a
`function` returning a `table` if you want to replace the default options completely.

We received a `%s` for plugin <%s>.]],
							type(user_config),
							plugin_name
						),
						vim.log.levels.ERROR,
						{ title = "[utils] Runtime Error (User Config)" }
					)
				end
			else
				-- 没有用户配置... 回退到插件的默认 setup
				setup_callback(opts)
			end
		end
	end
end

return M
