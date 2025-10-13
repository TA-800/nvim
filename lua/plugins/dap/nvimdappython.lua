return {
	plugin = {
		src = "https://github.com/mfussenegger/nvim-dap-python",
	},
	config = function()
		require("dap-python").setup("python")
	end,
}
