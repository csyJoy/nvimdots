local ui = {}

-- 启动仪表盘：Neovim 启动时显示的仪表盘界面
ui["goolord/alpha-nvim"] = {
	lazy = true,
	event = "BufWinEnter",
	config = require("ui.alpha"),
}
-- Buffer 标签栏：在顶部显示打开的 buffer 标签
ui["akinsho/bufferline.nvim"] = {
	lazy = true,
	event = { "BufReadPre", "BufAdd", "BufNewFile" },
	config = require("ui.bufferline"),
}
-- Catppuccin 主题：Catppuccin 配色主题（自定义 fork，refactor 分支）
ui["Jint-lzxy/nvim"] = {
	lazy = false,
	branch = "refactor/syntax-highlighting",
	name = "catppuccin",
	config = require("ui.catppuccin"),
}
-- Git 标记：在侧边栏显示 Git 状态标记（添加、修改、删除）
ui["lewis6991/gitsigns.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.gitsigns"),
}
-- 缩进参考线：显示垂直缩进参考线
ui["lukas-reineke/indent-blankline.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.indent-blankline"),
}
-- 状态栏：底部状态栏显示
ui["nvim-lualine/lualine.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("ui.lualine"),
}
-- 平滑滚动：提供平滑的滚动动画效果
ui["karb94/neoscroll.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.neoscroll"),
}
-- 通知系统：提供美观的通知显示（带动画）
ui["rcarriga/nvim-notify"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("ui.notify"),
}
-- 模式高亮：根据模式高亮指定的区域
ui["folke/paint.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.paint"),
}
-- 智能窗口分割：智能窗口导航和大小调整
ui["mrjones2014/smart-splits.nvim"] = {
	lazy = true,
	event = { "CursorHoldI", "CursorHold" },
	config = require("ui.splits"),
}
-- 窗口布局管理：管理侧边栏和浮动窗口布局
ui["folke/edgy.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.edgy"),
}
-- TODO 注释高亮：高亮 TODO、FIXME、NOTE 等注释
ui["folke/todo-comments.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.todo"),
	dependencies = "nvim-lua/plenary.nvim",
}
-- 滚动条显示：在侧边栏显示滚动条
ui["dstein64/nvim-scrollview"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("ui.scrollview"),
}

return ui
