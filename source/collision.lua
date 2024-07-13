function collides(collider2)
    if(collider1.x < collider2.x + collider2.width and
    collider1.x + collider1.width > collider2.x and
    collider1.y < collider2.y + collider2.height and
    collider1.y + collider1.height > collider2.y)
    then
        return true
    end
    return false
end