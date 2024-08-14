local seperators = require("kalpakavindu.icons").seperators
local log_icons = require("kalpakavindu.icons").log
local buffer_icons = require("kalpakavindu.icons").buffer

local filenameComp = {
	"filename",
	file_status = true,
	newfile_status = true,
	path = 0,
	shorting_target = 40,
	symbols = buffer_icons,
}

local diagnosticsComp = {
	"diagnostics",
	sources = { "nvim_diagnostic", "coc" },
	sections = { "error", "warn", "info", "hint" },
	symbols = log_icons,
	colored = true,
	update_in_insert = true,
	always_visible = false,
}

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = seperators.default.component,
		section_separators = seperators.default.section,
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { filenameComp },
		lualine_x = { diagnosticsComp, "encoding", "filetype" },
		lualine_y = { "filesize", "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
