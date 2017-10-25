Player = Drawable:extend()
Player:implement(Updatable)
Player:implement(Controllable)

Player.speed = 100

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
  if table.getn(self.projectiles) < self.maxProjectiles then
    log.debug('shooting...')
    local projectile = Projectile(
                        loader.Image.ShipParts.cannonBall,
                        self:getLocation(),
                        200,
                        self:getRotation(),
                        1000
                      )
    table.insert(self.projectiles, projectile)
  end
end

function Player:update(dt)
  self:getInput():update()

  if self:getInput():get 'shoot' ~= 0 then
    self:shoot()
  end

  if table.getn(self.projectiles) ~= 0 then
    for k, projectile in ipairs(self.projectiles) do
      projectile:update(dt)
      if not projectile:hasDistanceLeft() then
        table.remove(self.projectiles, k)
      end
    end
    log.debug('Projectile Count = '..table.getn(self.projectiles))
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
