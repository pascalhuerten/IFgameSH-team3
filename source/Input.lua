import "CoreLibs/object"

class("input").extends()

local myInputHandlers = {

    AButtonDown;

    cranked;

    --AButtonHeld()
    --
    --AButtonUp()
    --
    --BButtonDown()
    --
    --BButtonHeld()
    --
    --BButtonUp()
    --
    --downButtonDown()
    --
    --downButtonUp()
    --
    --leftButtonDown()
    --
    --leftButtonUp()
    --
    --rightButtonDown()
    --
    --rightButtonUp()
    --
    --upButtonDown()
    --
    --upButtonUp()
}

function input:init(player)
    myInputHandlers.cranked = player.crankedCallback;
    myInputHandlers.AButtonDown = player.AButtonDownCallback;
    playdate.inputHandlers.push(myInputHandlers)
end