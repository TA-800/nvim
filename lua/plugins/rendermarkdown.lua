return {
	plugin = {
		src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
	},
	config = function()
		require("render-markdown").setup({
			-- Filetypes this plugin will run on
			file_types = { "markdown", "copilot-chat" },
		})
	end,
}
