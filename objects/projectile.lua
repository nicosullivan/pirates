Projectile = Drawable:extend()
Projectile:implement(Updatable)
local sodapop = require('...utils.sodapop.sodapop')

--- Creates a new projectile.
-- @param image Image The image used for the projectile
-- @param loc Table The start location of the projectile formated {x,y}
-- @param speed Integer How fast the projectile moves
-- @param dir Float Radian of the direction the projectile is moving
-- @param distance Integer How far the projectile is going to move
-- @param startAnimation Animation The animation to play at the start of the Projectiles motion, will play at loc
function Projectile:new(image, loc, speed, dir, distance, startAnimationOptions, endAnimationOptions)
  Projectile.super.new(self,
    image,
    loc,
    0,
    { x = 1, y = 1 },
    { x = image:getWidth() / 2, y = image:getHeight() / 2 }
  )

  local startEnd = startAnimationOptions.onReachedEnd
  local projectile = self

  startAnimationOptions.onReachedEnd = function()
    if type(startEnd) == 'function' then
      startEnd()
    end
    projectile:setAnimatingStart(false)
  end

  local endEnd = endAnimationOptions.onReachedEnd

  endAnimationOptions.onReachedEnd = function()
    if type(endEnd) == 'function' then
      endEnd()
    end
    projectile:setAnimatingEnd(false)
  end

  -- Forces the animation to stop when done
  startAnimationOptions.stopAtEnd = true
  endAnimationOptions.stopAtEnd = false

  local animation = sodapop.newAnimatedSprite(loc.x, loc.y)
  animation:addAnimation('start', startAnimationOptions)
  animation:addAnimation('end', endAnimationOptions)
  animation:setAnchor(function()
    return projectile:getLocation().x, projectile:getLocation().y
  end)

  self:setSpeed(speed)
    :setDirection(dir)
    :setDistance(distance)
    :setSprite(animation)
    :setAnimatingStart(true)
end

--- Update function to be called during love.update()
-- @param dt Float deltaTime
function Projectile:update(dt)
  if not self:hasDistanceLeft() then
    self:setAnimatingEnd(true)
  end
  
  if self:isAnimatingStart() then
    self:getSprite():update(dt)
  elseif self:hasDistanceLeft() then
    local newDistance = self:getSpeed()*dt
    local newX = math.sin(self:getDirection()) * -newDistance
    local newY = math.cos(self:getDirection()) * newDistance
    local loc = self:getLocation()
    self:setLocation({
      x = loc.x + newX,
      y = loc.y + newY
    })
    self:addDistanceTraveled(newDistance)
  elseif self:isAnimatingEnd() then
    self:getSprite():update(dt)
  end
end

function Projectile:draw()
  if self:isAnimatingStart() then
    self:getSprite():draw()
  elseif self:hasDistanceLeft() then
    Projectile.super.draw(self)
  elseif self:isAnimatingEnd() then
    self:getSprite():draw()
  end
end

--- Function to see if Projectile is done traveling
-- @return bool
function Projectile:hasDistanceLeft()
  return self:getDistanceTraveled() <= self:getDistance()
end

--- Increases how long the projectile has traveled
function Projectile:addDistanceTraveled(dis)
  self:setDistanceTraveled(self:getDistanceTraveled() + dis)
  return self:getDistanceTraveled()
end

function Projectile:setSpeed(speed)
  self.speed = speed
  return self
end

function Projectile:getSpeed()
  return self.speed
end

function Projectile:setDirection(dir)
  self.direction = dir
  return self
end

function Projectile:getDirection()
  return self.direction
end

function Projectile:setDistance(dis)
  self:setDistanceTraveled(0)
    .distance = dis
  return self
end

function Projectile:getDistance()
  return self.distance
end

function Projectile:setDistanceTraveled(dist)
  self.distanceTraveled = dist
  return self
end

function Projectile:getDistanceTraveled()
  return self.distanceTraveled
end

function Projectile:setSprite(sprite)
  self.sprite = sprite
  return self
end

function Projectile:getSprite()
  return self.sprite
end

function Projectile:setAnimatingStart(animating)
  if animating then
    self:getSprite():switch('start')
  end
  self.animatingStart = animating
  return self
end

function Projectile:isAnimatingStart()
  return self.animatingStart
end

function Projectile:setAnimatingEnd(animatingEnd)
  if animatingEnd then
    self:getSprite():switch('end')
  end
  self.animatingEnd = animatingEnd
  return self
end

function Projectile:isAnimatingEnd()
  return self.animatingEnd
end

function Projectile:isAnimating()
  return self:isAnimatingStart() or self:hasDistanceLeft() or self:isAnimatingEnd()
end
