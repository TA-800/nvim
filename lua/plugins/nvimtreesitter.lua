return {
	url = "https://github.com/nvim-treesitter/nvim-treesitter",
	config = function() 
		require('nvim-treesitter').setup {
			auto_install = true,
			highlight = { enable = true, },
			indent = { enable = true, disable = {'ruby'} }
		} 
	end
}
