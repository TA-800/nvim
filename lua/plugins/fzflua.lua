return {
	url = "https://github.com/ibhagwan/fzf-lua",
	config = function()
		local fzf = require("fzf-lua")
		vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "[ ] Find existing buffers" })
	end,
}
