return {
	url = "https://github.com/mason-org/mason-lspconfig.nvim",
	config = function()
		-- LSP servers and clients are able to communicate to each other what features they support.
		-- By default, Neovim doesn't support everything that is in the LSP specification.
		-- When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
		-- So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Add any additional override configuration in the following tables. Available keys are:
		-- For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		-- * cmd (table): Override the default command used to start the server
		-- * filetypes (table): Override the default list of associated filetypes for the server
		-- * capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		-- * settings (table): Override the default settings passed when initializing the server.
		local servers = {
			basedpyright = {},
			lua_ls = {},
			-- See `:help lspconfig-all` for a list of all the pre-configured LSPs
			--
			-- Some languages (like typescript) have entire language plugins that can be useful:
			--    https://github.com/pmizio/typescript-tools.nvim
			--
			-- But for many setups, the LSP (`ts_ls`) will work just fine
			-- ts_ls = {},
			--
		}
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers or {}),
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for ts_ls)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
