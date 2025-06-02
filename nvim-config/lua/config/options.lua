-- Soft tabs, 4 spaces.
vim.opt.softtabstop = 4 -- How many spaces are applied when pressing Tab
vim.opt.shiftwidth = 4 -- Amount to indent with << and >>
vim.opt.tabstop = 4 -- How many spaces are shown per Tab
vim.opt.expandtab = true -- Convert tabs to spaces

-- On new line, position cursor at proper indentation.
vim.opt.autoindent = true -- Keep identation from previous line
vim.opt.smartindent = true
vim.opt.smarttab = true

-- Show line numbers
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
--vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
-- This is so that when LSP is enabled, the extra column w/ warnings/error
-- icons isn't randomly toggling on/off.
vim.opt.signcolumn = "yes"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.showtabline = 2
vim.opt.tabline = "%!lua return string.format('%s', MyTabLine())"

vim.cmd.colorscheme "default"
