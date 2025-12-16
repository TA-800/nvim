return {
	plugin = { src = "https://github.com/NeogitOrg/neogit" },
	config = function()
		vim.keymap.set("n", "<leader>ng", ":Neogit<CR>", {
			desc = " [N]eo[g]it",
		})
	end,
}
