vim.g.mapleader = " "

-- netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25

local M = vim.opt

M.nu = true
M.relativenumber = true

M.tabstop = 2
M.softtabstop = 2
M.shiftwidth = 2
M.expandtab = true

M.smartindent = true

M.wrap = false

M.swapfile = false
M.backup = false

if os.getenv("HOME") == nil then
	M.undodir = os.getenv("USERPROFILE") .. "/.vim/undodir"
else
	M.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

M.undofile = true

M.hlsearch = false
M.incsearch = true

M.termguicolors = true

M.scrolloff = 8
M.signcolumn = "yes"
M.isfname:append("@-@")

M.updatetime = 50

M.colorcolumn = "120"

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	severity_sort = false,
	undate_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})
