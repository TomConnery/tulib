--
-- Created by IntelliJ IDEA.
-- User: Leon
-- Date: 09.09.2018
-- Time: 14:03
-- To change this template use File | Settings | File Templates.
--


if not misc then
    os.loadAPI("util/misc.lua")
end

misc.loadAPIs({
    "util/constants.lua",
    "util/fuel.lua",

})

-- deprecated, use turtle.turnLeft(times) since it is overridden by tulib and has the same functionality
function turnLeft(times)
    for i = 0, times - 1 do
        turtle.turnLeft()
    end
end

-- deprecated, use turtle.turnRight(times) since it is overridden by tulib and has the same functionality
function turnRight(times)
    for i = 0, times - 1 do
        turtle.turnRight()
    end
end

-- moves the turtle to the first unoccupied side, returns true on success or false if the turtle is stuck
function moveToFirstUnoccupied()

    if fuel.isFueledOrRefuel(1) then
        if not turtle.forward() then
            for i=0, 3 do
                turtle.turnLeft()

                if turtle.forward() then
                    return true
                end
            end
        end
    end

    return false
end


