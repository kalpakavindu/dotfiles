local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_on_attach = function(_, buf)
	vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"

	local opts = { buffer = buf }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)

	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
end

require("fidget").setup({})

require("mason").setup({
	providers = {
		"mason.providers.client",
		"mason.providers.registry-api",
	},
	ui = {
		icons = {
			package_pending = " ",
			package_installed = " ",
			package_uninstalled = " ",
		},
	},

	max_concurrent_installers = 10,
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
})

require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "clangd", "gopls", "cmake", "tsserver", "typos_lsp", "cssls" },
	handlers = {
		-- default handler
		function(server_name)
			require("lspconfig")[server_name].setup({
				on_attach = lsp_on_attach,
				capabilities = capabilities,
			})
		end,

		["tsserver"] = function()
			local lspconfig = require("lspconfig")
			lspconfig.tsserver.setup({
				on_attach = lsp_on_attach,
				capabilities = capabilities,
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
			})
		end,

		-- handler for gopls
		["gopls"] = function()
			local lspconfig = require("lspconfig")
			lspconfig.gopls.setup({
				on_attach = lsp_on_attach,
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = { unusedparams = true },
					},
				},
			})
		end,

		-- handler for luals
		["lua_ls"] = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				on_attach = lsp_on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "Lua 5.1" },
						diagnostics = {
							globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
						},
					},
				},
			})
		end,

		["cssls"] = function()
			require("lspconfig").cssls.setup({
				on_attach = lsp_on_attach,
				capabilities = capabilities,
				filetypes = { "css", "less", "scss" },
				settings = {
					css = { validate = true },
					less = { validate = true },
					scss = { validate = true },
				},
			})
		end,

		["cmake"] = function()
			local lspconfig = require("lspconfig")
			lspconfig.cmake.setup({
				on_attach = lsp_on_attach,
				capabilities = capabilities,
				cmd = { "cmake-language-server" },
				filetypes = { "cmake" },
				root_dir = lspconfig.util.root_pattern(
					"CMakePresets.json",
					"CTestConfig.cmake",
					".git",
					"build",
					"cmake"
				),
			})
		end,

		["typos_lsp"] = function()
			require("lspconfig").typos_lsp.setup({
				on_attach = lsp_on_attach,
				capabilities = capabilities,
				cmd = { "typos-lsp" },
				filetypes = { "*" },
			})
		end,
	},
})
