vim.api.nvim_create_autocmd('BufEnter', {
  once = true,
  callback = function()
    -- nvim-lspconfig data repo
    vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
    vim.lsp.enable({ "lua_ls", "ty", "clangd" })

    vim.keymap.set("n", "grd", vim.diagnostic.setloclist, { desc = "Add buffer diagnostics to the location list" })
    -- :h vim.lsp.completion.get(), i_CTRL-X_CTRL_O default binding to invoke in LSP-enabled buffers
    -- vim.keymap.set('i', '<c-space>', vim.lsp.completion.get, desc = { ... })


    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(ev)
        -- :h lsp-attach

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method("textDocument/completion") then
          vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end

        if client:supports_method("textDocument/codeLens") then
          vim.lsp.codelens.enable(true, { bufnr = 0, client.id })
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            callback = function()
              vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
            end
          })
        end
      end
    })
  end
})
