-- [[ Keymaps to load plugins ]]
vim.keymap.set('n', '<leader>sf', function() 
	require('fzf-lua').files()
end)
