class("collider").extends()

function collider:init(params)
    self.width = params.width
    self.height = params.height
    self.x = params.x
    self.y = params.y
end