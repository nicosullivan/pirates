Drawable = Object:extend()

function Drawable:new(image, location, rotation, scale, offset)
  self:setImage(image)
    :setLocation(location)
    :setRotation(rotation)
    :setScale(scale)
    :setOffset(offset)
end

function Drawable:draw()
  love.graphics.draw(
    self.image,
    self.location.x,
    self.location.y,
    self.rotation,
    self.scale.x,
    self.scale.y,
    self.offset.x,
    self.offset.y
  )
end

function Drawable:setImage(image)
  self.image = image
  return self
end

function Drawable:getImage()
  return self.image
end

function Drawable:setLocation(location)
  self.location = location
  return self
end

function Drawable:getLocation()
  return self.location
end

function Drawable:setRotation(rotation)
  self.rotation = rotation
  return self
end

function Drawable:getRotation()
  return self.rotation
end

function Drawable:setScale(scale)
  self.scale = scale
  return self
end

function Drawable:getScale()
  return self.scale
end

function Drawable:setOffset(offset)
  self.offset = offset
  return self
end

function Drawable:getOffset()
  return self.offset
end
