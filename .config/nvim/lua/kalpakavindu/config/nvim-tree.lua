require("nvim-tree").setup({
	sort = { sorter = "case_sensitive" },
	view = { width = 32 },
	renderer = {
		group_empty = true,
		root_folder_label = false,
		highlight_git = true,
		indent_markers = { enable = true },
		icons = {
			glyphs = {
				default = "󰈚",
				folder = {
					default = "",
					empty = "",
					empty_open = "",
					open = "",
					symlink = "",
				},
				git = { unmerged = "" },
			},
		},
	},
	filters = { dotfiles = false },
})
