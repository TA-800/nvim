return {
	plugin = {
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		-- TODO: Change to main in the future
		version = "master",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "lua" }
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})

		-- Update all parsers when the treesitter plugin is updated
		vim.api.nvim_create_autocmd("PackChanged", {
			callback = function(event)
				if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
					vim.notify("Executing TSUpdate...")
					local ok = pcall(vim.cmd, "TSUpdate")
					if not ok then
						vim.notify("TSUpdate failed on PackChanged event", vim.log.levels.WARN)
					end
				end
			end,
		})
	end,
}
