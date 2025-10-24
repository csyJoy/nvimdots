-- =====================================================================
-- Mason-LSPConfig 配置：LSP 服务器自动安装和配置管理
-- =====================================================================
-- 本文件负责：
-- - 配置 mason-lspconfig 自动安装 LSP 服务器
-- - 设置诊断显示选项
-- - 为已安装的 LSP 服务器自动配置
-- - 处理服务器特定的设置（如 rust_analyzer, python-lsp-server）
-- - 监听包安装事件并执行后续配置
-- =====================================================================

local M = {}

M.setup = function()
	local is_windows = require("core.global").is_windows

	-- 从设置中获取需要安装的 LSP 服务器列表
	local lsp_deps = require("core.settings").lsp_deps
	local mason_registry = require("mason-registry")
	local mason_lspconfig = require("mason-lspconfig")

	-- ========== 配置 mason-lspconfig ==========
	-- 自动安装配置文件中指定的 LSP 服务器
	require("modules.utils").load_plugin("mason-lspconfig", {
		ensure_installed = lsp_deps,
		-- 跳过自动启用，因为我们使用懒加载方式加载语言服务器
		automatic_enable = false,
	})

	-- ========== 诊断显示配置 ==========
	-- 配置 LSP 诊断信息的显示方式
	vim.diagnostic.config({
		signs = true, -- 在行号列显示诊断符号
		underline = true, -- 在诊断位置下划线
		virtual_text = true, -- 不显示虚拟文本（使用 tiny-inline-diagnostic 替代）
		update_in_insert = false, -- 插入模式下不更新诊断
	})

	-- ========== LSP 客户端能力配置 ==========
	-- 定义所有 LSP 服务器的默认配置选项
	local opts = {
		capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(), -- LSP 协议基础能力
			require("cmp_nvim_lsp").default_capabilities() -- nvim-cmp 补全能力
		),
	}

	-- ========== LSP 服务器处理器函数 ==========
	-- 为 completion/servers/*.lua 下定义的所有服务器设置处理器
	---@param lsp_name string LSP 服务器名称
	local function mason_lsp_handler(lsp_name)
		-- ========== 特殊处理：rust_analyzer ==========
		-- rust_analyzer 由 mrcjkb/rustaceanvim 独立配置
		-- 如果用户手动设置了，发出警告
		if lsp_name == "rust_analyzer" then
			local config_exist = pcall(require, "completion.servers." .. lsp_name)
			if config_exist then
				vim.notify(
					[[
`rust_analyzer` is configured independently via `mrcjkb/rustaceanvim`. To get rid of this warning,
please REMOVE your LSP configuration (rust_analyzer.lua) from the `servers` directory and configure
`rust_analyzer` using the appropriate init options provided by `rustaceanvim` instead.]],
					vim.log.levels.WARN,
					{ title = "nvim-lspconfig" }
				)
			end
			return
		end

		-- ========== 加载服务器配置 ==========
		-- 1. 尝试加载用户自定义配置（user/configs/lsp-servers/{name}.lua）
		local ok, custom_handler = pcall(require, "user.configs.lsp-servers." .. lsp_name)
		-- 2. 尝试加载默认配置（completion/servers/{name}.lua）
		local default_ok, default_handler = pcall(require, "completion.servers." .. lsp_name)

		-- 如果没有用户定义，使用默认配置
		if not ok then
			ok, custom_handler = default_ok, default_handler
		end

		-- ========== 根据配置类型设置服务器 ==========
		if not ok then
			-- 情况 1：没有找到任何配置
			-- 使用工厂默认配置启动服务器
			require("modules.utils").register_server(lsp_name, opts)
		elseif type(custom_handler) == "function" then
			-- 情况 2：配置是函数
			-- 语言服务器需要自定义设置函数
			-- 确保在设置函数内调用 vim.lsp.config()
			-- 参考文档：|vim.lsp.config()|
			-- 示例：参见 clangd.lua
			custom_handler(opts)
			vim.lsp.enable(lsp_name)
		elseif type(custom_handler) == "table" then
			-- 情况 3：配置是表
			-- 合并默认配置、预设配置和用户配置
			require("modules.utils").register_server(
				lsp_name,
				vim.tbl_deep_extend(
					"force",
					opts, -- 基础选项
					type(default_handler) == "table" and default_handler or {}, -- 默认配置
					custom_handler -- 用户配置
				)
			)
		else
			-- 情况 4：配置类型无效
			vim.notify(
				string.format(
					"Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
					lsp_name,
					type(custom_handler)
				),
				vim.log.levels.ERROR,
				{ title = "nvim-lspconfig" }
			)
		end
	end

	-- ========== 包设置函数 ==========
	-- 简化版的 mason-lspconfig 1.x 的 setup_handlers 回调
	-- 为每个 Mason 包（包名或 Package 对象）配置其语言服务器
	---@param pkg string|{name: string} 包名（字符串）或 Package 对象
	local function setup_lsp_for_package(pkg)
		-- 1. 首先尝试获取内置的包名到 lspconfig 的映射
		local mappings = mason_lspconfig.get_mappings().package_to_lspconfig

		-- 2. 如果映射为空或不存在，手动构建映射表
		if not mappings or vim.tbl_isempty(mappings) then
			mappings = {}
			-- 遍历所有包规格，提取 lspconfig 映射
			for _, spec in ipairs(mason_registry.get_all_package_specs()) do
				local lspconfig = vim.tbl_get(spec, "neovim", "lspconfig")
				if lspconfig then
					mappings[spec.name] = lspconfig
				end
			end
		end

		-- 3. 确定包名并查找对应的 LSP 服务器
		local name = type(pkg) == "string" and pkg or pkg.name
		local srv = mappings[name]
		if not srv then
			-- 没有对应的 LSP 服务器，跳过
			return
		end

		-- 4. 调用处理器配置 LSP 服务器
		mason_lsp_handler(srv)
	end

	-- ========== 为已安装的包设置 LSP ==========
	-- 遍历所有已安装的 Mason 包并配置其 LSP 服务器
	for _, pkg in ipairs(mason_registry.get_installed_package_names()) do
		setup_lsp_for_package(pkg)
	end

	-- ========== Python LSP 服务器特殊处理 ==========
	-- 监听 Mason 包安装成功事件
	-- 当 python-lsp-server 安装后，自动安装额外的插件（black, ruff, rope）
	-- 然后使用 setup_lsp_for_package 配置已安装包的 LSP
	mason_registry:on(
		"package:install:success",
		vim.schedule_wrap(function(pkg)
			if pkg.name == "python-lsp-server" then
				-- ========== 确定 Python LSP 虚拟环境路径 ==========
				local venv = vim.fn.stdpath("data") .. "/mason/packages/python-lsp-server/venv"
				-- 根据操作系统确定可执行文件路径
				local python = is_windows and venv .. "/Scripts/python.exe" or venv .. "/bin/python"
				local black = is_windows and venv .. "/Scripts/black.exe" or venv .. "/bin/black"
				local ruff = is_windows and venv .. "/Scripts/ruff.exe" or venv .. "/bin/ruff"

				-- ========== 使用 pip 安装额外插件 ==========
				require("plenary.job")
					:new({
						command = python,
						args = {
							"-m",
							"pip",
							"install",
							"-U", -- 升级已安装的包
							"--disable-pip-version-check", -- 禁用版本检查加快安装
							"python-lsp-black", -- Black 格式化器集成
							"python-lsp-ruff", -- Ruff linter 集成
							"pylsp-rope", -- Rope 重构工具集成
						},
						cwd = venv,
						env = { VIRTUAL_ENV = venv },
						-- 安装完成回调
						on_exit = function()
							if vim.fn.executable(black) == 1 and vim.fn.executable(ruff) == 1 then
								vim.notify(
									"Finished installing pylsp plugins",
									vim.log.levels.INFO,
									{ title = "[lsp] Install Status" }
								)
							else
								vim.notify(
									"Failed to install pylsp plugins. [Executable not found]",
									vim.log.levels.ERROR,
									{ title = "[lsp] Install Failure" }
								)
							end
						end,
						-- 安装开始回调
						on_start = function()
							vim.notify(
								"Now installing pylsp plugins...",
								vim.log.levels.INFO,
								{ title = "[lsp] Install Status", timeout = 6000 }
							)
						end,
						-- 错误输出回调
						on_stderr = function(_, msg_stream)
							if msg_stream then
								vim.notify(msg_stream, vim.log.levels.ERROR, { title = "[lsp] Install Failure" })
							end
						end,
					})
					:start()
			end

			-- 为新安装的包设置 LSP
			setup_lsp_for_package(pkg)
		end)
	)
end

return M
