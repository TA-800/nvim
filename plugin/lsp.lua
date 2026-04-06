vim.api.nvim_create_autocmd('BufEnter', {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
    vim.lsp.enable({ "lua_ls", "ty", "clangd" })
    vim.keymap.set("n", "grd", vim.diagnostic.setloclist, { desc = "Add buffer diagnostics to the location list" })
  end
})
