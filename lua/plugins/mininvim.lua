return {
	url =  "https://github.com/nvim-mini/mini.nvim",
	config = function()
		--  va)  - [V]isually select [A]round [)]paren
		--  yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  ci'  - [C]hange [I]nside [']quote
		require('mini.ai').setup { n_lines = 500 }
		require('mini.surround').setup {}
		-- sr'"  - [S]urrond [R]eplace ' with "
		-- sd"   - [S]urrond [D]elete "
		-- saiw" - [S]urround [A]dd [I]nner [W]ord "
		require('mini.statusline').setup { use_icons = true }
		require('mini.icons').setup {}
	end,
}
