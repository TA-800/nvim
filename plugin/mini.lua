vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
    --  yinq - [Y]ank [I]nside [N]ext [Q]uote
    require("mini.ai").setup({ n_lines = 500 })
    -- sr'"  - [S]urrond [R]eplace ' with "
    -- sd"   - [S]urrond [D]elete "
    -- saiw" - [S]urround [A]dd [I]nner [W]ord "
    require("mini.surround").setup({})
  end
})
