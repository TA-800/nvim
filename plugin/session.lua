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

local function SelectSessionCo(handlingCo, items)
  vim.ui.select(items, { prompt = "Select session: " },
    function(selectedSession)
      coroutine.resume(handlingCo, selectedSession)
    end)
end

local function ActionSessionCo(handlingCo)
  vim.ui.select({ "Load", "Delete" }, { prompt = "Select action: " }, function(selectedAction)
    coroutine.resume(handlingCo, selectedAction)
  end)
end

local function await(f, ...)
  local self = coroutine.running()
  assert(self, "await can be only called inside a coroutine")
  local co = coroutine.create(f)
  local ok, ret = coroutine.resume(co, self, ...)
  if not ok then
    error("Coroutine returned error")
  end
  local result
  if not ret then
    result = coroutine.yield()
  end
  return result
end
local function ListCo()
  local selectedSession = await(SelectSessionCo, vim.fn.readdir(SESSION_DIR))
  print("Selected session: " .. selectedSession)

  -- TODO: if selectedSession nil then return

  local selectedAction = await(ActionSessionCo)
  print("Selected action: " .. selectedAction)

  -- TODO: if selectedAction = delete or nil, loop
end

vim.api.nvim_create_user_command("Sessions",
  function(opts)
    if opts.fargs[1] == "make" then
      CreateSession()
    else
      coroutine.wrap(ListCo)()
    end
  end, {
    nargs = "?"
  })

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  callback = SaveSessionIfExists
})
