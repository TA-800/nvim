return {
	-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
	-- used for completion, annotations and signatures of Neovim apis
	plugin = { src = "https://github.com/folke/lazydev.nvim" },
	config = function()
		require("lazydev").setup({
			library = {
				{
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		})
	end,
}
