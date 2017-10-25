Projectile = Drawable:extend()
Projectile:implement(Updatable)

--- Creates a new projectile.
-- @param image Image The image used for the projectile
-- @param loc Table The start location of the projectile formated {x,y}
-- @param speed Integer How fast the projectile moves
-- @param dir Float Radian of the direction the projectile is moving
-- @param distance Integer How far the projectile is going to move
-- @param startAnimation Animation The animation to play at the start of the Projectiles motion, will play at loc
function Projectile:new(image, loc, speed, dir, distance, startAnimation)
  Projectile.super.new(self,
    image,
    loc,
    0,
    { x = 1, y = 1 },
    { x = image:getWidth() / 2, y = image:getHeight() / 2 }
  )
  self:setSpeed(speed)
    :setDirection(dir)
    :setDistance(distance)
end

--- Update function to be called during love.update()
-- @param dt Float deltaTime
function Projectile:update(dt)
  local newDistance = self:getSpeed()*dt
  local newX = math.sin(self:getDirection()) * -newDistance
  local newY = math.cos(self:getDirection()) * newDistance
  if self:hasDistanceLeft() then
    local loc = self:getLocation()
    self:setLocation({
      x = loc.x + newX,
      y = loc.y + newY
    })
    self:addDistanceTraveled(newDistance)
  end
end

function Projectile:hasDistanceLeft()
  return self:getDistanceTraveled() <= self:getDistance()
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

function Projectile:addDistanceTraveled(dis)
  self:setDistanceTraveled(self:getDistanceTraveled() + dis)
  return self:getDistanceTraveled()
end

function Projectile:setDistanceTraveled(dist)
  self.distanceTraveled = dist
  return self
end

function Projectile:getDistanceTraveled()
  return self.distanceTraveled
end

function Projectile:setStartAnimation(animation)
  self.startAnimation = animation
  return self
end

function Projectile:getStartAnimation()
  return self.startAnimation
end
