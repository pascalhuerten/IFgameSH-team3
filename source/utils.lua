function lerp(a, b, t)
    return a + (b - a) * t
end

function convertDegreesToXY(angleInDegrees)
    local radians = degreesToRadians(angleInDegrees)
    local x = math.cos(radians)
    local y = math.sin(radians)
    return x, y
end

function degreesToRadians(degrees)
    return degrees * (math.pi / 180)
end