return {
	plugin = {
		src = "https://github.com/igorlfs/nvim-dap-view",
	},
	config = function()
		require("dap-view").setup({
			winbar = {
				controls = {
					enabled = true,
				},
			},
			auto_toggle = true,
		})
	end,
}
