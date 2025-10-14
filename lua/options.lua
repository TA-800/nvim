-- stylua: ignore start
-- General ====================================================================
vim.g.mapleader = " "              -- Use `<Space>` as <Leader> key
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.mouse       = "a"            -- Enable mouse
vim.o.undofile    = true           -- Enable persistent undo
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- UI =========================================================================
vim.o.breakindent    = true       -- Indent wrapped lines to match line start
vim.o.cursorline     = true       -- Enable current line highlighting
vim.o.list           = true       -- Show helpful text indicators
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand      = "split"   -- Preview window for search and replace cmds
vim.o.scrolloff      = 10
vim.o.number         = true       -- Show line numbers
vim.o.relativenumber = true       -- Show relative line numbers
vim.o.ruler          = false      -- Don't show cursor coordinates
vim.o.showmode       = false      -- Don't show mode in command line
vim.o.signcolumn     = 'yes'      -- Always show signcolumn (less flicker)
vim.o.splitbelow     = true       -- Horizontal splits will be below
vim.o.splitright     = true       -- Vertical splits will be to the right
vim.o.winborder      = 'solid'    -- Use border in floating windows

-- Editing ====================================================================
vim.o.autoindent    = true        -- Use auto indent
vim.o.expandtab     = true        -- Convert tabs to spaces
vim.o.tabstop       = 2           -- Show tab as this number of spaces
vim.o.shiftwidth    = 2           -- Use this number of spaces for indentation
vim.o.ignorecase    = true        -- Ignore case during search
vim.o.incsearch     = true        -- Show search matches while typing
vim.o.infercase     = true        -- Infer case in built-in completion
vim.o.smartcase     = true        -- Respect case if search pattern has upper case
vim.o.smartindent   = true        -- Make indenting smart

vim.o.foldmethod    = "expr"
vim.o.foldexpr      = vim.treesitter.foldexpr()
vim.o.foldlevelstart = 99
vim.o.confirm       = true        -- Confirm an operation that would fail due to unsaved changes (like :q)
-- stylua: ignore end
