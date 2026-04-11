--[[ Returns
  1. (string) filename that represents the session .vim for current working directory. Separators are replaced with "%" similar to in-built undotree files.
  2. (string) the directory where sessions are saved using stdpath("data") + /sessions/.
--]]
local GetSessionDetails = function()
  local cwd = vim.fn.getcwd()
  -- https://www.lua.org/pil/20.2.html, %w = alphanumeric chars, %W = complement of %W, % = escape char in Lua so %% = %
  local sessionName = string.gsub(cwd, "[%W]", "%%") .. ".vim"
  local sessionDir = vim.fs.normalize(vim.fn.stdpath("data")) .. "/sessions/"
  return sessionName, sessionDir
end

local SessionExists = function(sessionName, sessionDir)
  local existing = vim.fs.find(sessionName, { limit = 1, type = 'file', path = sessionDir })

  return #existing > 0
end

local Make = function()
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

local Load = function()
  -- TODO: Maybe add an extra function to be able to delete sessions?
  local _, sessionDir = GetSessionDetails()
  local items = vim.fn.readdir(sessionDir)
  vim.ui.select(items,
    {
      prompt = "Select session: ",
      format_item = function(item)
        return string.sub(string.gsub(item, "%%", "/"), 1, -5)
      end,
    },
    function(choice)
      if choice == nil then
        return
      end
      vim.api.nvim_cmd({
        cmd = "source",
        args = { sessionDir .. choice },
        magic = { file = false, bar = false }
      }, {})
      print("Session loaded.")
    end)
end

local SaveSessionIfExists = function()
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

vim.api.nvim_create_user_command("Sessions",
  function(opts)
    if opts.fargs[1] == "make" then
      Make()
    else
      Load()
    end
  end, {
    nargs = "?"
  })

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  callback = SaveSessionIfExists
})
