require("kalpakavindu.config")
require("kalpakavindu.lazy_init")
require("kalpakavindu.keymap")

local autocmd = vim.api.nvim_create_autocmd

local augroup = vim.api.nvim_create_augroup
local KalpaKavinduGrp = augroup("KalpaKavindu", {})
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 40 })
	end,
})

autocmd({ "BufWritePre" }, {
	group = KalpaKavinduGrp,
	pattern = "*",
	callback = function(args)
		local save_cursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]]) -- Remove all trailing whitespaces
		vim.api.nvim_win_set_cursor(0, save_cursor)

		local bufname = vim.api.nvim_buf_get_name(args.buf)
		if bufname:match("/node_modules/") or bufname:match("/vendor/") then
			return
		end

		require("conform").format({
			bufnr = args.buf,
		})
	end,
})

autocmd("BufEnter", {
	group = KalpaKavinduGrp,
	callback = function()
		pcall(vim.cmd.colorscheme, "tokyonight-night")
	end,
})

autocmd("LspAttach", {
	group = KalpaKavinduGrp,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, opts)
	end,
})
