return {
	"olexsmir/gopher.nvim",
	ft = "go",
	build = function()
		vim.cmd([[silent! GoInstallDeps]])
	end,
}
