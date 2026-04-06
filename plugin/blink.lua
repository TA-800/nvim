vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/Saghen/blink.cmp" })
    require("blink.cmp").setup({
      keymap = {
        preset = "enter",
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      },
      cmdline = {
        keymap = {
          preset = "inherit",
        },
      },
      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true },

        -- https://cmp.saghen.dev/recipes#mini-icons
        menu = {
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind" } },
          },
        },
      },

      sources = {
        default = { "lsp", "path" },
      },

      fuzzy = { implementation = "lua" },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    })
  end
})
