Controllable = Object:extend()

function Controllable:setControls(controls)
  self.controls = controls
  self.input.controls = self.controls
  return self
end

function Controllable:getControls()
  return self.controls
end

function Controllable:setInput(input)
  self.input = input
  return self
end

function Controllable:getInput()
  return self.input
end
