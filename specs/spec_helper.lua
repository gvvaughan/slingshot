--[[ ================ ]]--
--[[ Tmpfile manager. ]]--
--[[ ================ ]]--

local TMPDIR = os.getenv "TMPDIR" or os.getenv "TMP" or "/tmp"

local function push (t, x)
  return table.insert (t, x)
end

local function pop (t)
  return table.remove (t)
end

Tmpdir = setmetatable ({}, {
  __call = function (self, dirname)
    local obj = {}
    for k, v in pairs (self) do obj[k] = v end

    obj.path = dirname or TMPDIR .. "/mkrockspecs_" .. math.random (65535)
    obj.files = {}

    push (obj.files, obj.path)
    os.execute ("mkdir " .. obj.path)
    return setmetatable (obj, getmetatable (self))
  end,

  __index = {
    open = function (self, name, mode, ...)
      local path = self.path .. "/" .. name
      local h = io.open (path, mode)
      if h then
        push (self.files, path)
	if select ("#", ...) > 0 then
	  for _, s in ipairs {...} do h:write (s .. "\n") end
	  h:close ()
	end
      end
      return h
    end,

    subdir = function (self, name)
      local path = self.path .. "/" .. name
      push (self.files, path)
      return name
    end,

    remove = function (self)
      while #self.files > 0 do
	os.remove (pop (self.files))
      end
    end
  },
})
