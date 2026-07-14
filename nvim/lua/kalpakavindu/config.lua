vim.opt.guicursor = ''

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('USERPROFILE') .. '\\.vim\\undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50

vim.opt.colorcolumn = '170'

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.g.node_host_prog = os.getenv('NVM_SYMLINK') .. '\\node_modules\\neovim\\bin\\cli.js'

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- For github copilot
-- vim.g.copilot_node_command = os.getenv('NVM_SYMLINK') .. '\\node.exe'
