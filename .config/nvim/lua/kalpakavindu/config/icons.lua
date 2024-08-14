require("nvim-web-devicons").setup({
	color_icons = true,
	strict = true,
	default = true,
	override_by_filename = {
		[".gitignore"] = {
			icon = "",
			color = "#f1502f",
			name = "gitignore",
		},
		["go.mod"] = {
			icon = "󰟓",
			color = "#fddd00",
			name = "gomod",
		},
	},
	override_by_extension = {
		["log"] = {
			icon = "",
			color = "#81e043",
			name = "log",
		},
		["go"] = {
			icon = "󰟓",
			color = "#00acd7",
			name = "go",
		},
		["dart"] = {
			icon = "",
			color = "#66c3fa",
			name = "dart",
		},
	},
})
