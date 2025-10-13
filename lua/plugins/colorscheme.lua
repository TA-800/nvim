return {
	plugin = {
		src = "https://github.com/catppuccin/nvim",
	},
	config = function()
		-- catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
		vim.cmd("colorscheme catppuccin-latte")
	end,
}
