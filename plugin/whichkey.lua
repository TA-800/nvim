vim.api.nvim_create_autocmd('BufEnter', {
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/folke/which-key.nvim" })
    require("which-key").setup({ delay = 200 })
  end,
})
