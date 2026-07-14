return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },

	config = function()
		require("mason").setup()

		require("mason-tool-installer").setup({
			ensure_installed = {
				"clang-format",
				"autopep8",
				"stylua",
				"prettierd",
        "markdownlint"
			},
			auto_update = false,
			run_on_start = true,
			start_delay = 3000,
		})
	end,
}
