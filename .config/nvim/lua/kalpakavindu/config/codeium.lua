return function()
	vim.g.codeium_workspace_root_hints = { ".bzr", ".git", ".hg", ".svn", "_FOSSIL_", "package.json" }
	vim.g.codeium_disable_bindings = 1
	-- vim.g.codeium_enabled = false
	vim.g.codeium_filetypes_disabled_by_default = true

	vim.g.codeium_filetypes = {
		typescript = true,
		javascript = true,
		typescriptreact = true,
		javascriptreact = true,
		scss = true,
		css = true,
		html = true,
		lua = true,
	}

	vim.keymap.set("i", "<Tab>", function()
		return vim.fn["codeium#Accept"]()
	end, { expr = true, silent = true })

	-- vim.keymap.set("i", "<C-c>k", function()
	-- 	return vim.fn["codeium#CycleCompletions"](1)
	-- end, { expr = true, silent = true })

	vim.keymap.set("i", "<M-[>", function()
		return vim.fn["codeium#CycleCompletions"](-1)
	end, { expr = true, silent = true })

	vim.keymap.set("i", "<C-[>", function()
		return vim.fn["codeium#Clear"]()
	end, { expr = true, silent = true })

	vim.keymap.set("i", "<M-]>", function()
		return vim.fn["codeium#CycleOrComplete"]()
	end, { expr = true, silent = true })

	vim.keymap.set("n", "<leader>coh", function()
		return vim.fn["codeium#Chat"]()
	end, { expr = true, silent = true })
end
