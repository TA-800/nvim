-- https://github.com/
plugins = {
"https://github.com/nvim-lua/plenary.nvim", -- Dependency for many plugins
"https://github.com/folke/todo-comments.nvim",
"https://github.com/nvim-mini/mini.nvim", -- mini.ai, mini.surround, mini.statusline, mini.icons

"https://github.com/ibhagwan/fzf-lua",
"https://github.com/folke/which-key.nvim",
"https://github.com/NMAC427/guess-indent.nvim",
"https://github.com/lewis6991/gitsigns.nvim",

"https://github.com/nvim-treesitter/nvim-treesitter",
}

for _, url in ipairs(plugins) do
	vim.pack.add({ url })
end

-- Auto delete plugins in vim.pack.get() that are not present in current plugins table
for _, installed in ipairs(vim.pack.get()) do
	local found = false
	for _, url in ipairs(plugins) do
		if installed.spec.src == url then
			found = true
			break
		end
	end

	if not found then
		vim.pack.del({ installed.spec.name })
	end
end


-- Load these plugins immediately
require('mini.surround').setup {}
--  va)  - [V]isually select [A]round [)]paren
--  yinq - [Y]ank [I]nside [N]ext [Q]uote
--  ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup { n_lines = 500 }
require('mini.statusline').setup { use_icons = true }
require('mini.icons').setup {}

-- Highlight, edit, and navigate code
require('nvim-treesitter').setup {
	auto_install = true,
	highlight = { enable = true, },
	indent = { enable = true, disable = {'ruby'} }
}
