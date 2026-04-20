vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/nvim-mini/mini.ai" })
    --  yinq - [Y]ank [I]nside [N]ext [Q]uote
    require("mini.ai").setup({ n_lines = 500 })
  end
})
