Map = Drawable:extend()
Map:implement(Updatable)

Map.size = {height = 9, width = 15}
Map.tileSize = 128

function Map:new(imageMap)
  local tableCount = table.maxn(imageMap)
  local tiles = {}
  for i=1,Map.size.width,1 do
    tiles[i] = {}
    for j=1,Map.size.height,1 do
      tiles[i][j] = Tile(
                      imageMap[love.math.random(1,tableCount)],
                      {
                        x = (i-1)*Map.tileSize,
                        y = (j-1)*Map.tileSize
                      }
                    )
    end
  end
  self:setTiles(tiles)
end

function Map:draw()
  for _,value in ipairs(self:getTiles()) do
    for _,tile in pairs(value) do
      tile:draw()
    end
  end
end

function Map:setTiles(tiles)
  self.tiles = tiles
  return self
end

function Map:getTiles()
  return self.tiles
end

function Map:setTile(location, tile)
  self.tiles[location.x][location.y] = tile
  return self
end

function Map:getTile(location)
  return self.tiles[location.x][location.y]
end
