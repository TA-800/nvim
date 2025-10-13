return {
	plugin = {
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	config = function()
		require("nvim-treesitter").setup({
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
