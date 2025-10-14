return {
	plugin = {
		src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
	},
	config = function()
		local copilot = require("CopilotChat")
		copilot.setup({
			model = "claude-sonnet-4.5",
			window = {
				width = 0.3, -- 30% of screen width
			},
			headers = {
				user = "",
				assistant = "",
			},
			mappings = {
				-- Remove the default mappings for closing the chat buffer
				close = {
					normal = "",
					insert = "",
					callback = copilot.close,
				},
			},
		})
		-- Auto-command to customize chat buffer behavior
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-*",
			callback = function()
				vim.opt_local.number = false
			end,
		})
	end,
}
