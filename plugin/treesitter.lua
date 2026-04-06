vim.api.nvim_create_autocmd('BufEnter', {
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
    vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-context" })

    local treesitter = require("nvim-treesitter")
    treesitter.setup()
    treesitter.install({ "c", "cpp", "python", "lua" })

    -- Update parsers on Treesitter updates.
    vim.api.nvim_create_autocmd('PackChanged', {
      callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
          if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
          vim.cmd('TSUpdate')
        end
      end
    })
  end
})
