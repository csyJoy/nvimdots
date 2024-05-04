local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
require("keymap.helpers")

local plug_map = {
	["n|<leader>nt"] = map_cr("NvimTreeToggle"):with_noremap():with_silent():with_desc("filetree: Toggle"),
	["n|<leader>ft"] = map_cr("ToggleTerm direction=float")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle float"),
	["t|<leader>ft"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle float"),
	["t|jj"] = map_cmd([[<C-\><C-n>]]):with_noremap():with_silent(), -- switch to normal mode in terminal.
	["n|<leader>dr"] = map_callback(function()
			require("dap").continue()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Run/Continue"),
	["n|<leader>dd"] = map_callback(function()
			require("dap").terminate()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Stop"),
	["n|<leader>db"] = map_callback(function()
			require("dap").toggle_breakpoint()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Toggle breakpoint"),
	["n|<leader><tab>"] = map_callback(function()
			require("dap").step_into()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step into"),
	["n|<leader>do"] = map_callback(function()
			require("dap").step_out()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step out"),
	["n|<tab>"] = map_callback(function()
			require("dap").step_over()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step over"),
	["n|m"] = map_callback(function()
			require("dap").step_back()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step back"),
	["n|<leader>dB"] = map_callback(function()
			require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Set breakpoint with condition"),
	["n|<leader>dc"] = map_callback(function()
			require("dap").run_to_cursor()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Run to cursor"),
	["n|<leader>dl"] = map_callback(function()
			require("dap").run_last()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Run last"),
	["n|<leader>dp"] = map_callback(function()
			require("dap").repl.open()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Open REPL"),
	--plugin: ChatGPT
	["n|<leader>a"] = map_cr("ChatGPT"):with_noremap():with_silent():with_desc("ChatGPT"),
	["n|<leader>cas"] = map_cr("ChatGPTActAs"):with_noremap():with_silent():with_desc("ChatGPT Act As"),
	["v|<leader>cag"] = map_cr("ChatGPTRun grammer_correction")
		:with_noremap()
		:with_silent()
		:with_desc("Grammar Correction"),
	["v|<leader>cat"] = map_cr("ChatGPTRun translate"):with_noremap():with_silent():with_desc("Translate"),
	["v|<leader>cak"] = map_cr("ChatGPTRun keywords"):with_noremap():with_silent():with_desc("Keywords"),
	["v|<leader>cad"] = map_cr("ChatGPTRun docstring"):with_noremap():with_silent():with_desc("Docstring"),
	["v|<leader>cae"] = map_cr("ChatGPTRun add_tests"):with_noremap():with_silent():with_desc("Add Test"),
	["v|<leader>cao"] = map_cr("ChatGPTRun optimize_code"):with_noremap():with_silent():with_desc("Optimize Code"),
	["v|<leader>cas"] = map_cr("ChatGPTRun summarize"):with_noremap():with_silent():with_desc("Summary"),
	["v|<leader>caf"] = map_cr("ChatGPTRun fix_bugs"):with_noremap():with_silent():with_desc("Fix Bugs"),
	["v|<leader>cap"] = map_cr("ChatGPTRun explain_code"):with_noremap():with_silent():with_desc("Explain"),
	["v|<leader>cax"] = map_cr("ChatGPTRun roxygen_edit"):with_noremap():with_silent():with_desc("Roxygen Edit"),
	["v|<leader>car"] = map_cr("ChatGPTRun code_readability_analysis")
		:with_noremap()
		:with_silent()
		:with_desc("Code Readability Analysis"),
	["v|<leader>cai"] = map_cr("ChatGPTEditWithInstructions")
		:with_noremap()
		:with_silent()
		:with_desc("Edit With Instructions"),

	--plugin: refactoring.nvim
	["x|<leader>re"] = map_cr("Refactor extract"):with_noremap():with_silent():with_desc("Extract Function"),
	["x|<leader>rf"] = map_cr("Refactor extract_to_file")
		:with_noremap()
		:with_silent()
		:with_desc("Extract Function To File"),
	["x|<leader>rv"] = map_cr("Refactor extract_var"):with_noremap():with_silent():with_desc("Extract Variable"),
	["x|<leader>ri"] = map_cr("Refactor inline_var"):with_noremap():with_silent():with_desc("Inline Variable"),
	["n|<leader>ri"] = map_cr("Refactor inline_var"):with_noremap():with_silent():with_desc("Inline Variable"),
	["n|<leader>rI"] = map_cr("Refactor inline_func"):with_noremap():with_silent():with_desc("Inline Function"),
	["n|<leader>rb"] = map_cr("Refactor extract_block"):with_noremap():with_silent():with_desc("Inline Block"),
	["n|<leader>rbf"] = map_cr("Refactor extract_block_to_file")
		:with_noremap()
		:with_silent()
		:with_desc("Inline Block To File"),

	--plugin: obsidian.nvim
	["n|<leader>fo"] = map_cr("ObsidianSearch"):with_noremap():with_silent():with_desc("find: obsidian word"),
	["n|<leader>oo"] = map_cr("ObsidianOpen")
		:with_noremap()
		:with_silent()
		:with_desc("Obsidian: open current file in obsidian"),
	["n|<leader>ot"] = map_cr("ObsidianToday"):with_noremap():with_silent():with_desc("Obsidian: open today daily"),
	["n|<leader>oy"] = map_cr("ObsidianYesterday")
		:with_noremap()
		:with_silent()
		:with_desc("Obsidian: open yesterday daily"),
	["n|<leader>om"] = map_cr("ObsidianTomorrow")
		:with_noremap()
		:with_silent()
		:with_desc("Obsidian: open tomorrow daily"),
	["n|<leader>ov"] = map_cr("ObsidianPasteImg")
		:with_noremap()
		:with_silent()
		:with_desc("Obsidian: paste image in clipboard"),

	--plugin: demo.nvim
	["n|<leader>fl"] = map_cr("GenerateFlashcards")
		:with_noremap()
		:with_silent()
		:with_desc("Obsidian: generate flashcards"),

	["v|<leader>nl"] = map_callback(function()
			local text = require("demo").get_selected_text()
			vim.cmd("ObsidianLinkNew" .. " " .. text .. ".md")
		end)
		:with_noremap()
		:with_silent()
		:with_desc("Obsidian: link to new note"),
}

return plug_map
