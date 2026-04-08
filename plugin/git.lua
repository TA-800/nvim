vim.api.nvim_create_autocmd('BufEnter', {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })
  end
})
