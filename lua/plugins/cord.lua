return {
	plugin = {
		src = "https://github.com/vyfor/cord.nvim",
	},
	config = function()
		require("cord").setup({
			editor = {
				tooltip = "Moving at the speed of thought",
			},
			text = {
				-- Ignore when interacting with copilot-chat
				viewing = function(opts)
					if string.find(opts.filename, "copilot") then
						return "Thinking..."
					else
						return "Viewing " .. opts.filename
					end
				end,
				editing = function(opts)
					if string.find(opts.filename, "copilot") then
						return "Thinking..."
					else
						return "Editing " .. opts.filename
					end
				end,
			},
			display = {
				flavor = "accent",
				swap_icons = true,
			},
		})
	end,
}
