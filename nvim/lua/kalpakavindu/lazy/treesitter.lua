return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile", "VeryLazy" },
		config = function()
			local ts = require("nvim-treesitter")
			ts.install({
				"lua",
				"vim",
				"vimdoc",
				"query",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"json",
				"gitignore",
				"go",
				"c",
				"cpp",
			})

			vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
				pattern = "*",
				callback = function(args)
					-- Skip non-file buffers (terminal, dashboards, etc.)
					if vim.bo[args.buf].buftype ~= "" then
						return
					end

					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft) or ft

					-- Check if parser is missing, and if so, attempt to download it
					if not vim.treesitter.language.add(lang) then
						local available = pcall(function()
							ts.install(lang)
						end)
						if not available then
							return
						end
					end

					-- Use the standard core Neovim attachment method
					pcall(vim.treesitter.start, args.buf, lang)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		init = function()
			vim.g.no_plugin_maps = true -- Prevent default runtime conflicts
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
					},
				},
			})
		end,
	},
}
