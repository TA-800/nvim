return {
	plugin = {
		src = "https://github.com/theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		require("nvim-dap-virtual-text").setup({
			virt_text_pos = "eol",
		})
	end,
}
