-- =====================================================================
-- LSP 配置主入口：初始化和配置语言服务器
-- =====================================================================
-- 本文件负责：
-- - 设置 neoconf（项目级 LSP 配置）
-- - 配置 mason（LSP 安装管理器）
-- - 配置 mason-lspconfig（Mason 和 lspconfig 的桥接）
-- - 设置 LSP 客户端能力（capabilities）
-- - 注册不受 mason 支持但可用的 LSP 服务器（如 dartls）
-- - 加载用户自定义 LSP 配置
-- - 启动所有配置的 LSP 服务器
-- =====================================================================

return function()
	-- ========== 加载 LSP 相关配置模块 ==========
	-- 1. neoconf: 提供项目级别的 LSP 配置支持（.neoconf.json）
	require("completion.neoconf").setup()

	-- 2. mason: LSP/DAP/Linter/Formatter 安装管理器
	require("completion.mason").setup()

	-- 3. mason-lspconfig: Mason 和 nvim-lspconfig 之间的桥接
	require("completion.mason-lspconfig").setup()

	-- ========== LSP 客户端能力配置 ==========
	-- 设置 LSP 客户端的能力（capabilities）
	-- 整合 nvim-cmp 的补全能力到 LSP 协议中
	local opts = {
		capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	}

	-- ========== 注册不受 Mason 支持的 LSP 服务器 ==========
	-- 某些 LSP 服务器在 nvim-lspconfig 中可用，但不受 mason.nvim 支持
	-- 需要手动配置和启动这些服务器
	--
	-- 配置步骤：
	--   1. 调用 vim.lsp.config() 配置服务器
	--   2. 调用 vim.lsp.enable() 启动服务器（或使用 register_server）

	-- Dart LSP 服务器配置（适用于 Flutter/Dart 开发）
	if vim.fn.executable("dart") == 1 then
		-- 尝试加载用户自定义的 dartls 配置
		local ok, _opts = pcall(require, "user.configs.lsp-servers.dartls")
		if not ok then
			-- 如果用户没有自定义配置，使用默认配置
			_opts = require("completion.servers.dartls")
		end
		-- 合并默认 opts 和服务器特定配置
		local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
		-- 注册并启动 dartls 服务器
		require("modules.utils").register_server("dartls", final_opts)
	end

	-- ========== 加载用户自定义 LSP 配置 ==========
	-- 用户可以在 user/configs/lsp.lua 中添加额外的 LSP 配置
	-- 例如：自定义服务器、覆盖默认设置等
	pcall(require, "user.configs.lsp")

	-- ========== 启动所有 LSP 服务器 ==========
	-- 启动所有已配置的语言服务器
	-- 使用 pcall 防止启动失败导致配置中断
	pcall(vim.cmd.LspStart)
end
