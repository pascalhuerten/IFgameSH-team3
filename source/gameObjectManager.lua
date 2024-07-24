class("GameObjectManager").extends()

function GameObjectManager:init()
    self.objects = {}
    self.previousCollisions = {}
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
    local currentCollisions = {}

    -- Find objects that are active and have collision enabled
    for _, object in ipairs(self.objects) do
        if object.active and object.activeCollision then
            table.insert(activeObjects, object)
        end
    end

    -- Detect collisions
    for i = 1, #activeObjects do
        for j = i + 1, #activeObjects do
            -- if self:checkCollision(activeObjects[i], activeObjects[j]) then
            if self:checkCircleCollision(activeObjects[i], activeObjects[j]) then
                print("Detected collision for", activeObjects[j].className, activeObjects[i].className)
                local collisionPair = tostring(activeObjects[i]) .. tostring(activeObjects[j])
                -- Mark as collided in current cycle
                currentCollisions[collisionPair] = true

                -- If not collided in previous cycle, call onCollisionEnter
                if not self.previousCollisions[collisionPair] then
                    activeObjects[i]:onCollisionEnter(activeObjects[j])
                    activeObjects[j]:onCollisionEnter(activeObjects[i])
                end
                
                -- Finally call onCollision for both objects
                activeObjects[i]:onCollision(activeObjects[j])
                activeObjects[j]:onCollision(activeObjects[i])
            end
        end
    end

    -- Update previous collisions for the next cycle
    self.previousCollisions = currentCollisions
end

function GameObjectManager:checkCollision(object1, object2)
    return object1.x < object2.x + object2.width and
           object1.x + object1.width > object2.x and
           object1.y < object2.y + object2.height and
           object1.y + object1.height > object2.y
end



function GameObjectManager:checkCircleCollision(object1, object2)
    local rad1 = math.rad(object1.direction) -- Convert direction of object1 to radians
    local rad2 = math.rad(object2.direction) -- Convert direction of object2 to radians

    for _, circle1 in ipairs(object1.collisionCircles) do
        -- Rotate circle1's position
        local rotatedX1 = circle1[1] * math.cos(rad1) - circle1[2] * math.sin(rad1)
        local rotatedY1 = circle1[1] * math.sin(rad1) + circle1[2] * math.cos(rad1)
        local absX1 = object1.x + rotatedX1
        local absY1 = object1.y + rotatedY1

        for _, circle2 in ipairs(object2.collisionCircles) do
            -- Rotate circle2's position
            local rotatedX2 = circle2[1] * math.cos(rad2) - circle2[2] * math.sin(rad2)
            local rotatedY2 = circle2[1] * math.sin(rad2) + circle2[2] * math.cos(rad2)
            local absX2 = object2.x + rotatedX2
            local absY2 = object2.y + rotatedY2

            local dx = absX1 - absX2
            local dy = absY1 - absY2
            local distance = math.sqrt(dx^2 + dy^2)
            if distance < (circle1[3] + circle2[3]) then
                return true
            end
        end
    end
    return false
end