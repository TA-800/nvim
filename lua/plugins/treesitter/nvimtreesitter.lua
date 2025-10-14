return {
	plugin = {
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup()
		treesitter.install({ "c", "cpp", "python", "lua" })

		-- Update all parsers when the treesitter plugin is updated
		vim.api.nvim_create_autocmd("PackChanged", {
			callback = function(event)
				if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
					local ok = pcall(vim.cmd, "TSUpdate")
					if not ok then
						vim.notify("TSUpdate failed on PackChanged event", vim.log.levels.WARN)
					end
				end
			end,
		})
	end,
}
