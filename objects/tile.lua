Tile = Drawable:extend()

function Tile:new(image, loc)
  Tile.super.new(self,
    image,
    loc,
    0,
    { x = 1, y = 1 },
    { x = 0, y = 0 }
  )
end
