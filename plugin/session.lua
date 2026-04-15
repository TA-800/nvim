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
  -- TODO: Need to close LSPs as well?

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

local function SelectSessionCo(items, orchestratorCo)
  print("Running SelectSessionCo")
  vim.ui.select(items, { prompt = "Select session: " },
    function(selectedSession)
      print("coroutine.resume(orchestratorCo, session) inside SelectSessionCo vim.ui callback")
      coroutine.resume(orchestratorCo, selectedSession)
    end)
end

local function ActionSessionCo(selectedSession, orchestratorCo)
  print("Running ActionSessionCo with " .. selectedSession)
  vim.ui.select({ "Load", "Delete" }, { prompt = "Select action: " }, function(selectedAction)
    print("coroutine.resume(orchestratorCo, selectedAction)")
    coroutine.resume(orchestratorCo, selectedAction)
  end)
end

local function OrchestratorCo()
  print("Running OrchestratorCo")
  local selectSessionCo = coroutine.create(SelectSessionCo)
  local ok, ret = coroutine.resume(selectSessionCo, vim.fn.readdir(SESSION_DIR), coroutine.running())
  print("OrchestratorCo: Returning from SelectSessionCo")
  if not ok then error("OrchestratorCo: SelectSessionCo error") end
  local selectedSession
  if not ret then
    -- First yield becuase first yield from select session co will return nothing
    -- Then coroutine.resume(orchestratorCo, selectedSession) from select callback will resume here
    print("OrchestratorCo: Yielding control to main thread, waiting for selectedSession")
    selectedSession = coroutine.yield()
    print("OrchestratorCo: Resuming with selectedSession " .. selectedSession)
  end

  local actionSessionCo = coroutine.create(ActionSessionCo)
  ok, ret = coroutine.resume(actionSessionCo, selectedSession, coroutine.running())
  print("OrchestratorCo: Returning from ActionSessionCo")
  if not ok then error("OrchestratorCo: ActionSessionCo error") end
  local selectedAction
  if not ret then
    print("OrchestratorCo: Yielding control to main thread, waiting for selectedAction")
    selectedAction = coroutine.yield()
    print("OrchestratorCo: Resuming with selectedAction " .. selectedAction)
  end

  print("Selected session: " .. selectedSession)
  print("Selected action: " .. selectedAction)
end

vim.api.nvim_create_user_command("Sessions",
  function(opts)
    if opts.fargs[1] == "make" then
      CreateSession()
    else
      coroutine.wrap(OrchestratorCo)()
    end
  end, {
    nargs = "?"
  })

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  callback = SaveSessionIfExists
})
