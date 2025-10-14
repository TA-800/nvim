-- NOTE: Originally this was inside lspconfig.lua but for whatever reason there ends up being two instances of an LSP. Bringing it here seems to solve the issue?
-- WARN: LSP names should match the names here: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
vim.lsp.enable({
	--LSP
	"lua_ls",
	"basedpyright",
	"clangd",
})
