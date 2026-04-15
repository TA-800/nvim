-- TODO: cache sessionDir

---Get session-related details
---@return string sessionName The filename that represents the session .vim for current working directory. Separators are replaced with "%" similar to in-built undotree files.
---@return string sessionDir The directory where sessions are saved using stdpath("data") + /sessions/.
function GetSessionDetails()
  local cwd = vim.fn.getcwd()
  -- https://www.lua.org/pil/20.2.html, %w = alphanumeric chars, %W = complement of %W, % = escape char in Lua so %% = %
  local sessionName = string.gsub(cwd, "[%W]", "%%") .. ".vim"
  local sessionDir = vim.fs.normalize(vim.fn.stdpath("data")) .. "/sessions/"
  return sessionName, sessionDir
end

function SessionExists(sessionName, sessionDir)
  local existing = vim.fs.find(sessionName, { limit = 1, type = 'file', path = sessionDir })

  return #existing > 0
end

---If this current directory exists as a session then save it.
function SaveSessionIfExists()
  local sessionName, sessionDir = GetSessionDetails()
  if not SessionExists(sessionName, sessionDir) then
    return
  end

  local session = sessionDir .. sessionName
  vim.api.nvim_cmd({
    cmd = "mksession",
    args = { session },
    bang = true, -- ! to override existing
    magic = { file = false, bar = false }
  }, {})
  print("Session saved.")
end

function Make()
  local sessionName, sessionDir = GetSessionDetails()
  -- Create session directory, p for silently exit if exists
  vim.fn.mkdir(sessionDir, "p")
  if SessionExists(sessionName, sessionDir) then
    print("Existing session detected. Session will be auto-saved on exit.")
    return
  end

  local session = sessionDir .. sessionName
  vim.api.nvim_cmd({
    cmd = "mksession",
    args = { session },
    magic = { file = false, bar = false }
  }, {})
  print("Session created.")
end

function LoadSession(sessionDir, choice)
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
    args = { sessionDir .. choice },
    magic = { file = false, bar = false }
  }, {})
  print("Session loaded.")
end

function SelectSession()
  -- TODO: Add Load or Delete action on choosing session, but don't introduce inconveniences like having to execute :Sessions again to open up the session selection menu.
  -- TODO: Use coroutines for readable code: https://www.reddit.com/r/neovim/comments/1sjoshj/asyncawait_like_behavior_with_lua_coroutines/
  -- 1. Open session selection with vim.ui.select.
  -- 2. On session selection, open action selection (Load or Delete) with vim.ui.select.
  -- 3. On Load, load session. On Delete, delete session and open session selection again.
  -- 1.5. Cancel session selection if user cancels/aborts dialog (choice == null).
  local _, sessionDir = GetSessionDetails()
  local items = vim.fn.readdir(sessionDir)
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
      -- TODO: Wrap in a Load() function
      -- Also add command to close all current buffers in 1st session before loading a new 2nd one
      -- because buffers opened in 1st before switching to 2nd remain,
      -- then get saved into that switched 2nd session's session.vim,
      -- then get opened up every time when 2nd session is loaded.
      -- Maybe before Load, save current session then close buffers then load new session.
      LoadSession(sessionDir, choice)
    end)
end

vim.api.nvim_create_user_command("Sessions",
  function(opts)
    if opts.fargs[1] == "make" then
      Make()
    else
      SelectSession()
    end
  end, {
    nargs = "?"
  })

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  callback = SaveSessionIfExists
})
