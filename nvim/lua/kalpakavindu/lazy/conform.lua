return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				python = { "autopep8" },
				lua = { "stylua" },
				go = { "gofmt" },
				markdown = { "markdownlint" },

				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				scss = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				jsonc = { "prettierd", "prettier" },
				yaml = { "prettierd", "prettier" },
				txt = {},
				["_"] = { "prettierd", "prettier" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
			},
		})

		vim.keymap.set("n", "<leader>fmt", function()
			require("conform").format({ bufnr = 0 })
		end)
	end,
}
