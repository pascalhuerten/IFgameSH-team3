class("GameObjectManager").extends()

function GameObjectManager:init()
    self.objects = {}
end

function GameObjectManager:registerObject(object)
    table.insert(self.objects, object)
    -- print("Registered object ", object.className)
    return #self.objects
end

function GameObjectManager:destroyObject(object)
    for i, v in pairs(self.objects) do
        if(v == object) then 
            -- print("Destroyed object ", object.className)
            table.remove(self.objects, i)
            return
        end
    end
end

function GameObjectManager:update()
    for _, object in pairs(self.objects) do
        if object.active then
            object:update()
        end
    end
end

function GameObjectManager:draw()
    for _, object in pairs(self.objects) do
        if object.active then
            object:draw()
        end
    end
end

function GameObjectManager:drawCollisionBorder()
    for _, object in pairs(self.objects) do
        if object.active then
            object:drawCollisionBorder()
        end
    end
end

function GameObjectManager:drawHealth()
    for _, object in pairs(self.objects) do
        if object.active then
            object:drawHealth()
        end
    end
end

function GameObjectManager:detectCollision()
    local activeObjects = {}
    for _, object in ipairs(self.objects) do
        if object.active and object.activeCollision then
            table.insert(activeObjects, object)
        end
    end


    for i = 1, #activeObjects do
        for j = i + 1, #activeObjects do
            -- if self:checkCollision(activeObjects[i], activeObjects[j]) then
            if self:checkCircleCollision(activeObjects[i], activeObjects[j]) then
                print("Detected collision for", activeObjects[j].className, activeObjects[i].className)
                activeObjects[i]:onCollision(activeObjects[j])
                activeObjects[j]:onCollision(activeObjects[i])
            end
        end
    end
end

function GameObjectManager:checkCollision(object1, object2)
    return object1.x < object2.x + object2.width and
           object1.x + object1.width > object2.x and
           object1.y < object2.y + object2.height and
           object1.y + object1.height > object2.y
end



function GameObjectManager:checkCircleCollision(object1, object2)
    for _, circle1 in ipairs(object1.collisionCircles) do
        for _, circle2 in ipairs(object2.collisionCircles) do
            local dx = (object1.x + circle1[1]) - (object2.x + circle2[1])
            local dy = (object1.y + circle1[2]) - (object2.y + circle2[2])
            local distance = math.sqrt(dx^2 + dy^2)
            if distance < (circle1[3] + circle2[3]) then
                return true
            end
        end
    end
    return false
end