local dap = require("dap")
local ui = require("dapui")

ui.setup()
require("dap-go").setup()

require("nvim-dap-virtual-text").setup({
	display_callback = function(variable)
		local name = string.lower(variable.name)
		local val = string.lower(variable.value)
		if name:match("secret") or name:match("api") or val:match("api") or val:match("secret") then
			return "*****"
		end

		if #variable.value > 15 then
			return " " .. string.sub(variable.value, 1, 15) .. " ...  "
		end
		return " " .. variable.value
	end,
})

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)

vim.keymap.set("n", "<leader>?", function()
	require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<leader>d1", dap.continue)
vim.keymap.set("n", "<leader>d2", dap.step_into)
vim.keymap.set("n", "<leader>d3", dap.step_over)
vim.keymap.set("n", "<leader>d4", dap.step_out)
vim.keymap.set("n", "<leader>d5", dap.step_back)
vim.keymap.set("n", "<leader>dr", dap.restart)

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end

dap.listeners.before.launch.dapui_config = function()
	ui.open()
end

dap.listeners.before.event_transmitted.dapui_config = function()
	ui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end
