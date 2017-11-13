local autoloader = {
 _version = '0.1.0',
 _prefix = '[AUTOLOADER] ',
 retryLimit = 10
}

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
  self:log('debug', 'Loading Files')

  files = {}
  
  self.retryCount = 0

  self:recursiveEnumerate(dir, files)

  self:loadFiles(files)

  self:log('debug', 'Done loading files')
end

function autoloader:loadFiles(files)
  local retry = {}

  if self.retryCount > self.retryLimit then
    self:log('error', 'Retry limit reached')
    for _, file in pairs(files) do 
      self:log('info', 'Unable to load file: ' .. file:sub(1, -5))
    end
    return
  end

  self.retryCount = self.retryCount + 1

  for _, file in pairs(files) do 
    local index = file:sub(1, -5)
    self:log('trace', 'Loading File ' .. index)
    xpcall(require, function(err) 
        self:log('warn', 'Failed loading file '.. index)
        self:log('warn', err)
        _LOADED[index] = nil
        table.insert(retry, file)
      end,
      index
    )
  end

  if table.getn(retry) ~= 0 then
    self:log('trace', 'Number of files not loaded : '.. table.getn(retry))
    self:loadFiles(retry)
  end
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
