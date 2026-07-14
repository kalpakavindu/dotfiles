-- Netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open File Explorer" })

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fgf", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>cls", builtin.colorscheme, { desc = "Telescope colorscheme" })
vim.keymap.set("n", "<leader>fgc", builtin.git_commits, { desc = "Telescope git commits" })
vim.keymap.set("n", "<leader>fgs", builtin.git_status, { desc = "Telescope git status" })
vim.keymap.set("n", "<leader>fgb", builtin.git_branches, { desc = "Telescope git branches" })
vim.keymap.set("n", "<leader>ts", builtin.treesitter, { desc = "Telescope treesitter" })

-- Comment
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })

-- Custom
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

-- Copy paste
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Move lines down
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("i", "<A-Down>", "<cmd>m .+1<cr><esc>==gi", { desc = "Move line down" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- Move lines up
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<A-Up>", "<cmd>m .-2<cr><esc>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
