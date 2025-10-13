local plugin_files = {
	"plugins.plenary",
	"plugins.treesitter.nvimtreesitter",
	"plugins.treesitter.nvimtreesittercontext",
	-- Utils (mini.ai, .statusline, .surround, .icons)
	"plugins.mininvim",
	"plugins.guessindent",
	"plugins.fzflua",
	"plugins.todocomments",
	"plugins.whichkey",
	-- LSPs
	"plugins.lsp.lazydev",
	"plugins.lsp.mason",
	"plugins.lsp.blink",
	"plugins.lsp.lspconfig",
	"plugins.lsp.autoformatter",
	"plugins.lsp.fidget",
	-- DAP
	"plugins.dap.nvimdap",
	"plugins.dap.nvimnio",
	"plugins.dap.nvimdapview",
	"plugins.dap.nvimdapvirtualtext",
	"plugins.dap.nvimdappython",
	-- Git
	"plugins.gitsigns",
	"plugins.diffview",
	"plugins.neogit",
	-- Colorscheme
	"plugins.colorscheme",
}

local plugins = {}
for _, file in ipairs(plugin_files) do
	local M = require(file)
	vim.pack.add({ M.plugin })
	-- immediately load the plugins by calling their setup/config method
	if M.config then
		M.config()
	end
	-- track installed plugin so we can autodelete untracked plugins that are installed
	plugins[M.plugin.src] = true
end

-- Auto delete plugins in vim.pack.get() that are not present in current plugins table
for _, installed in ipairs(vim.pack.get()) do
	if not plugins[installed.spec.src] then
		vim.pack.del({ installed.spec.name })
	end
end

-- List installed packages
vim.api.nvim_create_user_command("VimPackInstalled", function()
	for i, installed in ipairs(vim.pack.get()) do
		print(string.format("%s %s", i, installed.spec.name))
	end
end, { desc = "List installed packages" })
