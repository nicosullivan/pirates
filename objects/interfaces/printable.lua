Printable = Object:extend()

function Printable:print()
  love.graphics.print(self.text, self.x, self.y)
end
