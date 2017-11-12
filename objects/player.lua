Player = Drawable:extend()
Player:implement(Updatable)
Player:implement(Controllable)

Player.speed = 100
Player.shootCooldown = 1
Player.logPrefix = "[Player] "

function Player:new(image, loc)
  Player.super.new(self,
    image,
    loc,
    0,
    { x = 1, y = 1 },
    { x = image:getWidth() / 2, y = image:getHeight() / 2 }
  )

  local controls = {
      left = {'key:left', 'key:a'},
      right = {'key:right', 'key:d'},
      up = {'key:up', 'key:w'},
      down = {'key:down', 'key:s'},
      shoot = {'key:space'}
  }

  self:setInput(baton.new(
                  controls,
                  love.joystick.getJoysticks()[1]
  ))
    :setControls(controls)

  self.hasShot = false
  self.projectiles = {}
  self.maxProjectiles = 50
  self.shootTime = 0
end

function Player:move(x, y)
  local loc = self:getLocation()
  self:setLocation({
    x = loc.x + x,
    y = loc.y + y
  })
  return self
end

function Player:rotate(degrees)
  self:setRotation(self:getRotation() + degrees)
  return self
end

function Player:shoot()
  if table.getn(self.projectiles) < self.maxProjectiles and not self:isShooting() then
    log.trace(Player.logPrefix..'Shooting')
    self:resetShoot()
    local projectile = Projectile(
                        loader.Image.ShipParts.cannonBall,
                        self:getLocation(),
                        400,
                        self:getRotation(),
                        1000,
                        {
                          image = loader.Image.shootAnimationHighRes,
                          frameWidth = 128,
                          frameHeight = 128,
                          stopAtEnd = true,
                          frames = {
                            {1, 1, 9, 1, .025}
                          }
                        },
                        {
                          image = loader.Image.explosionSpriteSheet,
                          frameWidth = 75,
                          frameHeight = 75,
                          stopAtEnd = true,
                          frames = {
                            {1, 1, 3, 1, .1}
                          }
                        }
                      )
    table.insert(self.projectiles, projectile)
  end
end

function Player:updateShootTimer(amount)
  self.shootTime = self.shootTime + amount
  if self.shootTime >= Player.shootCooldown then
    self.shooting = false
  end
  return self
end

function Player:resetShoot()
  self.shootTime = 0
  self.shooting = true
end

function Player:isShooting()
  return self.shooting
end

function Player:update(dt)
  self:getInput():update()
  self:updateShootTimer(dt)
  if self:getInput():get 'shoot' ~= 0 then
    self:shoot()
  end

  if table.getn(self.projectiles) ~= 0 then
    for k, projectile in ipairs(self.projectiles) do
      projectile:update(dt)
      if not projectile:isAnimating() then
        table.remove(self.projectiles, k)
      end
    end
  end

  local rotation = self:getInput():get 'right' - self:getInput():get 'left'
  local currentDirection = self:rotate(dt*rotation):getRotation()
  local forward = self:getInput():get 'down' - self:getInput():get 'up'
  local x = math.sin(currentDirection) * forward
  local y = math.cos(currentDirection) * -forward
  self:move(dt*x*Player.speed, dt*y*Player.speed)
end

function Player:draw()
  self.super.draw(self)
  if table.getn(self.projectiles) ~= 0 then
    for _, projectile in ipairs(self.projectiles) do
      projectile:draw()
    end
  end
end

function Player:getProjectileCount()
  return table.getn(self.projectiles)
end
