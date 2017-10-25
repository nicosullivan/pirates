Object = require('utils.classic.classic')
log = require('utils.log.log')
lurker = require('utils.lurker.lurker')
debugGraph = require('utils.debugGraph.debugGraph')
anim8 = require('utils.anim8.anim8')
loader = require('utils.loader.loader')
baton = require('utils.baton.baton')
autoloader = require('utils.autoloader')

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

  world = loader.Image.UIpackSheet_transparent
  local uiGrid = anim8.newGrid(16, 16, world:getWidth(), world:getHeight(), -2, -2, 2)
  mouse = anim8.newAnimation(uiGrid('1-2', 33), 1)

  player = Player(loader.Image.Ships.ship2, { x = 200, y = 200 })
  map = Map({
    loader.Image.Tiles.tile_73,
    loader.Image.Tiles.tile_68
  })
end

function love.update(dt)

-- TODO list of updates
  player:update(dt)
  map:update(dt)

  lurker:update()
  for _, g in pairs(graphs) do
    g:update(dt)
  end
  mouse:update(dt)
end

function love.draw()
  -- TODO is drawable
  map:draw()
  player:draw()

  for _, g in pairs(graphs) do
    g:draw()
  end
  mouse:draw(world, 599, 899, 0, 1, 1)
end
