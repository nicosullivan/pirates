Object = require('utils.classic.classic')
log = require('utils.log.log')
lurker = require('utils.lurker.lurker')
debugGraph = require('utils.debugGraph.debugGraph')
loader = require('utils.loader.loader')
baton = require('utils.baton.baton')
autoloader = require('utils.autoloader')
gamera = require('utils.gamera.gamera')
sodapop = require('utils.sodapop.sodapop')

lurker.preswap = function(f) log.info('File ' .. f .. ' was swapped') end
log.outfile = 'logs/error.log'
log.usecolor = false
log.level = 'trace'

function love.load()

  love.graphics.setDefaultFilter('nearest', 'nearest')

  loader.setBaseImageDir('assets/images')
  loader.setBaseAudioDir('assets/audio')
  loader.setBaseFontDir('assets/fonts')
  loader.init()

  autoloader:setLogger(log)
  autoloader:load('objects')

  graphs = {}
  graphs.fps = debugGraph:new('fps', 0, 0, 300, 150)
  graphs.mem = debugGraph:new('mem', 0, 150, 300, 150)
  graphs.projectiles = debugGraph:new('custom', 0, 300, 300, 150)

  player = Player(loader.Image.Ships.ship2, { x = 200, y = 200 })
  map = Map({
    loader.Image.Tiles.tile_73,
    loader.Image.Tiles.tile_68
  })
  local mapSize = map:getPixelSize()
  cam = gamera.new(0,0,mapSize.width,mapSize.height)
end

function love.update(dt)

-- TODO list of updates
  player:update(dt)
  map:update(dt)

  lurker:update()
  graphs.fps:update(dt)
  graphs.mem:update(dt)
  graphs.projectiles:update(dt, player:getProjectileCount())
  graphs.projectiles.label = "Projectiles: " .. player:getProjectileCount()

  local shipPos = player:getLocation()
  cam:setPosition(shipPos.x, shipPos.y)
end

function love.draw()
  -- TODO is Drawable

  cam:draw(function(l,t,w,h)
    map:draw()
    player:draw()
  end)

  for _, g in pairs(graphs) do
    g:draw()
  end
end
