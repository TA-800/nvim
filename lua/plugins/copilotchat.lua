return {
	plugin = {
		src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
	},
	config = function()
		local copilot = require("CopilotChat")
		copilot.setup({
			mappings = {
				-- Remove the default mappings for closing the chat buffer
				close = {
					normal = "",
					insert = "",
					callback = copilot.close,
				},
			},
		})
	end,
}
