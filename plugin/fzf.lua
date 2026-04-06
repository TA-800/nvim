vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })
    local fzf = require("fzf-lua")
    fzf.setup({ files = { formatter = "path.filename_first" } })
    -- Replace vim.ui.select with fzf picker
    fzf.register_ui_select()

    vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "[ ] Find existing buffers" })
    -- Shortcut for searching for your Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      fzf.files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[S]earch [N]eovim files" })
  end
})
