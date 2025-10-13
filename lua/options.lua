vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
-- Schedule the setting after UiEnter because it can increase startup-time.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
-- If this many milliseconds nothing is typed the swap file will be written to disk (see |crash-recovery|).  Also used for the |CursorHold| autocommand event.
vim.o.updatetime = 250
vim.o.timeoutlen = 300
-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
-- vim.opt is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- NOTE: Neovide bug with 'split': https://github.com/neovim/neovim/issues/24802
vim.o.inccommand = "nosplit"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.winborder = "solid"
vim.o.foldmethod = "expr"
vim.o.foldexpr = vim.treesitter.foldexpr()
vim.o.foldlevelstart = 99
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true
