return {
	plugin = { src = "https://github.com/folke/which-key.nvim" },
	config = function()
		require("which-key").setup({
			delay = 200,
		})
	end,
}
