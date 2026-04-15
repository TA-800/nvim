local SESSION_DIR = vim.fs.normalize(vim.fn.stdpath("data")) .. "/sessions/"
-- If this file is "require"d then ensure /sessions/ dir exists.
vim.fn.mkdir(SESSION_DIR, "p")

---Get name of .vim file that would save current session
---@return string sessionName The filename that represents the session .vim for current working directory. Separators are replaced with "%" similar to in-built undotree files.
local function GetNameForCurrentSession()
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  local sessionName = string.gsub(cwd, "[/:]", "%%") .. ".vim"
  return sessionName
end

local function SessionExists(sessionName)
  local existing = vim.fs.find(sessionName, { limit = 1, type = 'file', path = SESSION_DIR })

  return #existing > 0
end

---If this current directory exists as a session then save it.
local function SaveSessionIfExists()
  local sessionName = GetNameForCurrentSession()
  if not SessionExists(sessionName) then
    return
  end

  local session = SESSION_DIR .. sessionName
  vim.api.nvim_cmd({
    cmd = "mksession",
    args = { session },
    bang = true, -- ! to override existing
    magic = { file = false, bar = false }
  }, {})
  print("Session saved.")
end

local function CreateSession()
  local sessionName = GetNameForCurrentSession()
  if SessionExists(sessionName) then
    print("Existing session detected. Session will be auto-saved on exit.")
    return
  end

  local session = SESSION_DIR .. sessionName
  vim.api.nvim_cmd({
    cmd = "mksession",
    args = { session },
    magic = { file = false, bar = false }
  }, {})
  print("Session created.")
end

local function LoadSession(choice)
  SaveSessionIfExists()

  -- Close existing buffers
  local buffers = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buffers) do
    if vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end

  -- Load selected session
  vim.api.nvim_cmd({
    cmd = "source",
    args = { SESSION_DIR .. choice },
    magic = { file = false, bar = false }
  }, {})
  print("Session loaded.")
end

local function SelectSession()
  -- TODO: Add Load or Delete action on choosing session, but don't introduce inconveniences like having to execute :Sessions again to open up the session selection menu.
  -- TODO: Use coroutines for readable code: https://www.reddit.com/r/neovim/comments/1sjoshj/asyncawait_like_behavior_with_lua_coroutines/
  -- 1. Open session selection with vim.ui.select.
  -- 2. On session selection, open action selection (Load or Delete) with vim.ui.select.
  -- 3. On Load, load session. On Delete, delete session and open session selection again.
  -- 1.5. Cancel session selection if user cancels/aborts dialog (choice == null).
  local items = vim.fn.readdir(SESSION_DIR)
  vim.ui.select(items,
    {
      -- TODO: If Load/Delete implemented then prompt = "Select session (cancel to escape): "
      prompt = "Select session: ",
      format_item = function(item)
        -- Convert %% to / just for viewing, and also remove ".vim"
        return string.sub(string.gsub(item, "%%", "/"), 1, -5)
      end,
    },
    function(choice)
      if choice == nil then
        return
      end
      LoadSession(choice)
    end)
end

vim.api.nvim_create_user_command("Sessions",
  function(opts)
    if opts.fargs[1] == "make" then
      CreateSession()
    else
      SelectSession()
    end
  end, {
    nargs = "?"
  })

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  callback = SaveSessionIfExists
})
