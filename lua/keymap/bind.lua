-- =====================================================================
-- 快捷键绑定工具类：使用 Builder 模式创建快捷键映射
-- =====================================================================
-- 本文件提供：
-- - rhs_options 类：用于构建快捷键配置的链式 API
-- - 工厂函数：map_cr, map_cmd, map_cu, map_args, map_callback
-- - nvim_load_mapping：批量加载快捷键映射的函数
--
-- 设计模式：Builder 模式 - 通过链式调用构建复杂的配置对象
--
-- 使用示例：
--   map_cr("Lazy"):with_silent():with_noremap():with_desc("package: Show")
-- =====================================================================

-- ========== rhs_options 类定义 ==========
-- 快捷键右侧选项类（Right-Hand Side Options）
-- 支持链式调用方法来构建快捷键配置
---@class map_rhs
---@field cmd string 命令字符串
---@field options table 选项配置表
---@field options.noremap boolean 是否禁用递归映射
---@field options.silent boolean 是否静默执行（不显示命令行消息）
---@field options.expr boolean 是否将映射视为表达式
---@field options.nowait boolean 是否不等待其他映射
---@field options.callback function 回调函数
---@field options.desc string 快捷键描述（用于 which-key 显示）
---@field buffer boolean|number buffer 编号（false 表示全局）
local rhs_options = {}

-- 创建新的 rhs_options 实例
---@return map_rhs
function rhs_options:new()
	local instance = {
		cmd = "",
		options = {
			noremap = false,
			silent = false,
			expr = false,
			nowait = false,
			callback = nil,
		},
		buffer = false,
	}
	setmetatable(instance, self)
	self.__index = self
	return instance
end

-- ========== 命令映射方法 ==========

-- 直接映射命令字符串（不添加任何前缀或后缀）
---@param cmd_string string 命令字符串
---@return map_rhs 返回自身以支持链式调用
function rhs_options:map_cmd(cmd_string)
	self.cmd = cmd_string
	return self
end

-- 映射为 Ex 命令（添加 : 前缀和 <CR> 后缀）
-- 示例：map_cr("Lazy") -> ":Lazy<CR>"
---@param cmd_string string 命令字符串
---@return map_rhs 返回自身以支持链式调用
function rhs_options:map_cr(cmd_string)
	self.cmd = (":%s<CR>"):format(cmd_string)
	return self
end

-- 映射为需要参数的命令（添加 : 前缀和空格后缀）
-- 示例：map_args("edit") -> ":edit "
---@param cmd_string string 命令字符串
---@return map_rhs 返回自身以支持链式调用
function rhs_options:map_args(cmd_string)
	self.cmd = (":%s<Space>"):format(cmd_string)
	return self
end

-- 映射为可视模式命令（使用 <C-u> 清除自动插入的范围）
-- 示例：map_cu("normal! ==") -> ":<C-u>normal! ==<CR>"
---@param cmd_string string 命令字符串
---@return map_rhs 返回自身以支持链式调用
function rhs_options:map_cu(cmd_string)
	-- <C-u> 用于在可视模式下清除自动插入的范围
	self.cmd = (":<C-u>%s<CR>"):format(cmd_string)
	return self
end

-- 映射为回调函数
-- 按键按下时将调用指定的回调函数
---@param callback fun():nil 回调函数
---@return map_rhs 返回自身以支持链式调用
function rhs_options:map_callback(callback)
	self.cmd = ""
	self.options.callback = callback
	return self
end

-- ========== 选项配置方法（链式调用）==========

-- 设置 silent 选项（静默执行，不显示命令行消息）
---@return map_rhs 返回自身以支持链式调用
function rhs_options:with_silent()
	self.options.silent = true
	return self
end

-- 设置快捷键描述（在 which-key 中显示）
---@param desc_string string 描述字符串
---@return map_rhs 返回自身以支持链式调用
function rhs_options:with_desc(desc_string)
	self.options.desc = desc_string
	return self
end

-- 设置 noremap 选项（禁用递归映射）
---@return map_rhs 返回自身以支持链式调用
function rhs_options:with_noremap()
	self.options.noremap = true
	return self
end

-- 设置 expr 选项（将映射视为表达式）
---@return map_rhs 返回自身以支持链式调用
function rhs_options:with_expr()
	self.options.expr = true
	return self
end

-- 设置 nowait 选项（不等待其他映射）
---@return map_rhs 返回自身以支持链式调用
function rhs_options:with_nowait()
	self.options.nowait = true
	return self
end

-- 设置 buffer 选项（限定快捷键作用范围到特定 buffer）
---@param num number buffer 编号
---@return map_rhs 返回自身以支持链式调用
function rhs_options:with_buffer(num)
	self.buffer = num
	return self
end

-- ========== 工厂函数 ==========
-- 提供便捷的快捷键创建函数
local bind = {}

-- 创建 Ex 命令映射（最常用）
-- 示例：bind.map_cr(":cmd_string<CR>")
---@param cmd_string string 命令字符串
---@return map_rhs 新的 rhs_options 实例
function bind.map_cr(cmd_string)
	local ro = rhs_options:new()
	return ro:map_cr(cmd_string)
end

-- 创建直接命令映射(:cmd_string)
---@param cmd_string string 命令字符串
---@return map_rhs 新的 rhs_options 实例
function bind.map_cmd(cmd_string)
	local ro = rhs_options:new()
	return ro:map_cmd(cmd_string)
end

-- 创建可视模式命令映射(:<C-u>cmd_string<CR>)
---@param cmd_string string 命令字符串
---@return map_rhs 新的 rhs_options 实例
function bind.map_cu(cmd_string)
	local ro = rhs_options:new()
	return ro:map_cu(cmd_string)
end

-- 创建带参数的命令映射
---@param cmd_string string 命令字符串
---@return map_rhs 新的 rhs_options 实例
function bind.map_args(cmd_string)
	local ro = rhs_options:new()
	return ro:map_args(cmd_string)
end

-- 创建回调函数映射
---@param callback fun():nil 回调函数
---@return map_rhs 新的 rhs_options 实例
function bind.map_callback(callback)
	local ro = rhs_options:new()
	return ro:map_callback(callback)
end

-- 转义终端代码
-- 将特殊键码转换为 Neovim 可识别的格式
---@param cmd_string string 包含特殊键码的字符串
---@return string escaped_string 转义后的字符串
function bind.escape_termcode(cmd_string)
	return vim.api.nvim_replace_termcodes(cmd_string, true, true, true)
end

-- ========== 批量加载映射函数 ==========
-- 从映射表中批量加载快捷键
--
-- 映射表格式：
--   {
--     ["n|<leader>ff"] = map_cr("Telescope find_files"):with_noremap():with_silent(),
--     ["v|<leader>y"] = map_cmd('"+y'):with_noremap(),
--   }
--
-- 键格式：[模式]|[快捷键]
--   - 模式可以是：n(normal), v(visual), i(insert), t(terminal) 等
--   - 多个模式可以组合：nv|<leader>y
---@param mapping table<string, map_rhs> 快捷键映射表
function bind.nvim_load_mapping(mapping)
	for key, value in pairs(mapping) do
		-- 解析键：modes|keymap
		local modes, keymap = key:match("([^|]*)|?(.*)")
		if type(value) == "table" then
			-- 遍历每个模式（支持 "nv" 这样的多模式组合）
			for _, mode in ipairs(vim.split(modes, "")) do
				local rhs = value.cmd
				local options = value.options
				local buf = value.buffer
				-- 根据 buffer 选项选择不同的 API
				if buf and type(buf) == "number" then
					-- buffer 局部映射
					vim.api.nvim_buf_set_keymap(buf, mode, keymap, rhs, options)
				else
					-- 全局映射
					vim.api.nvim_set_keymap(mode, keymap, rhs, options)
				end
			end
		end
	end
end

return bind
