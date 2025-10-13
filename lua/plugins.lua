local plugin_files = {
	"plugins.plenary",
	"plugins.nvimtreesitter",
	-- Utils (mini.ai, .statusline, .surround, .icons)
	"plugins.mininvim",
	"plugins.guessindent",
	"plugins.fzflua",
	"plugins.todocomments",
	"plugins.whichkey",
	-- LSPs
	"plugins.lazydev",
	"plugins.mason",
	"plugins.blink",
	"plugins.lspconfig",
	"plugins.autoformatter",
	"plugins.fidget",
	-- Git
	"plugins.gitsigns",
	"plugins.diffview",
	"plugins.neogit",
}

local plugins = {}
for _, file in ipairs(plugin_files) do
	local plugin = require(file)
	vim.pack.add({ plugin.url })
	-- immediately load the plugins by calling their setup/config method
	if plugin.config then
		plugin.config()
	end
	-- track installed plugin so we can autodelete untracked plugins that are installed
	plugins[plugin.url] = true
end
--
--
-- Auto delete plugins in vim.pack.get() that are not present in current plugins table
for _, installed in ipairs(vim.pack.get()) do
	if not plugins[installed.spec.src] then
		vim.pack.del({ installed.spec.name })
	end
end
