return {
	plugin = {
		src = "https://github.com/mfussenegger/nvim-dap",
	},
	config = function()
		vim.keymap.set("n", "<leader>b", ":DapToggleBreakpoint<CR>", { desc = "Toggle [B]reakpoint" })
		vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { desc = "Start debugging session" })
	end,
}
