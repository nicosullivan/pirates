local autoloader = { _version = '0.1.0', _prefix = '[autoloader] ' }

function autoloader:recursiveEnumerate(folder, file_list)
  local items = love.filesystem.getDirectoryItems(folder)
  for _, item in ipairs(items) do
      local file = folder .. '/' .. item
      if love.filesystem.isFile(file) then
          table.insert(file_list, file)
      elseif love.filesystem.isDirectory(file) then
          self:log('trace', 'Entering Dir ' .. file)
          self:recursiveEnumerate(file, file_list)
      end
  end
end

function autoloader:load(dir)
  self:log('debug', 'Loading Files...')

  files = {}
  self:recursiveEnumerate(dir, files)

  for _, file in pairs(files) do
    local index = file:sub(1, -5)
    self:log('trace', 'Loading File ' .. index)
    require(index)
  end

  self:log('debug', 'Done loading files...')
end

function autoloader:log(type, string)
  string = self._prefix .. string
  if self.logger then
      self.logger[type](string)
  end
end

function autoloader:setLogger(logger)
  self.logger = logger
end

return autoloader
