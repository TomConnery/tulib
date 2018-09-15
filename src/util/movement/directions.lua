--
-- Created by IntelliJ IDEA.
-- User: Leon
-- Date: 09.09.2018
-- Time: 17:24
-- To change this template use File | Settings | File Templates.
--


if _G.misc == nil then
    os.loadAPI("util/misc.lua")
end

-- override defult turning methods
if not turtle.legacyTurnLeft then
    turtle.legacyTurnLeft = turtle.turnLeft
    turtle.turnLeft = function(times)
        
    end
end

if not turtle.legacyTurnRight then

end

misc.loadAPIs({
    "util/movement/movement.lua",
    "util/fuel.lua",
    "util/logging/logging.lua",
    "util/vardump.lua"
})

------------------------------
-- variables


--the directions are left-aligned, which allows for easy selection via counted turns and the respective array

north = 0 --negative z / 3rd compound
west = 1 --negative x / 1st compound
south = 2 --positive z / 3rd compound
east = 3 --positive x / 1st compound
up = 4 --positive y / 2nd compound
down = 5 --negative y / 2nd compound

directions = {
    north,
    west,
    south,
    east,
    up,
    down
}

directionStrings = {
    "north",
    "west",
    "south",
    "east",
    "up",
    "down"
}


-- CONFIGURATION

findGPSTimeout = 1
dTurnSpeed = 0.3


------------------------------

--returns the direction-int associated with the provided string
function directionIntOf(str)
    for i, v in ipairs(directionStrings) do
        if (v == str) then
            return i - 1
        end
    end
    logging.logWithLevel("directions#directionIntOf was provided with a non mapped value: " .. tostring(str), loglevel.warning)
    return nil
end

--returns the respective directionString of a direction-mapped integer
function directionStringOf(val)
    return directionStrings[val + 1]
end


--returns the respective direction which results from a one-block movement of a turtle
function directionOf(vectorA, vectorB)

    local vectorC = vectorB - vectorA

    if vectorC.x ~= 0 then
        if vectorC.x > 0 then
            return east
        else
            return west
        end

    elseif vectorC.z ~= 0 then
        if vectorC.z > 0 then
            return south
        else
            return north
        end

    elseif vectorC.y ~= 0 then
        if vectorC.y > 0 then
            return up
        else
            return down
        end

    else
        --        logging.logWithLevel("vectorA:\n" .. vardump.to_string(vectorA), loglevel.debug)
        --        logging.logWithLevel("vectorB:\n" .. vardump.to_string(vectorB), loglevel.debug)
        --        logging.logWithLevel("vectorC:\n" .. vardump.to_string(vectorC), loglevel.debug)
        return nil
    end
end


--  checks whether GPS is enabled via checking for a modem first and then checking gps
function isGPSEnabled()

    if peripheral.find("modem") == nil then
        return false
    elseif gps.locate(findGPSTimeout) == nil then
        return true
    end

    return true
end

--  This function returns whteher the function executed properly and a string which represents
--  the direction the turtle is currently facing ("nort", "south", "east", "west")
--
--  copied and edited from http://www.computercraft.info/forums2/index.php?/topic/1704-get-the-direction-the-turtle-face/
--  original author is Lyqyd
function getOrientation(breakBlocks)
    --
    -- This program was inspired by the above named template, it was, however, optimized for less block breakages
    -- The orientation is deduced from the turns the turtle has to make in order to be able to move and the
    -- difference in coordinates after moving one block in the next possible direction
    --

    if not fuel.isFueledOrRefuel(2) then
        logging.logWithLevel("util.directions#getOrientation requires at least two fuel units, the turtle however does not have enough fuel for this action", loglevel.error)
        return false, nil
    end

    --  check whether GPS is enabled at all
    if not isGPSEnabled() then
        if not modem.isWireless() then
        end
        logging.logWithLevel("Cannot aquire direction without working GPS (please read up on util.directions#getOrientation and how to set up GPS in ComputerCraft)", loglevel.error)
        return false, nil
    end

    local loc1 = vector.new(gps.locate(2, false))

    --  These are left-turns
    local turns = 0

    if not turtle.forward() then
        --          Not being able to move forward means we have to first find a place we can move to
        --          Break blocks if you are allowed to in order to move
        if not movement.moveToFirstUnoccupied() then



            if not breakBlocks then
                logging.logWithLevel("Tried to get location but was not able to move without breaking blocks and having breakBlocks set to true", loglevel.error)
                return false, nil
            else

                logging.logWithLevel("Breaking blocks now in order to be able to move", loglevel.debug)

                if not turtle.dig() then

                    local dug = false

                    for i = 1, 3 do

                        turtle.turnLeft()
                        turns = turns + 1
                        sleep(dTurnSpeed)

                        if turtle.dig() then
                           dug = true
                            break
                        end
                    end

                    if not dug then
                        logging.logWithLevel("Tried to get location but was not able to move and not able to dig (using safeword \"turtle\")!", loglevel.error)
                        return false, nil
                    end

                end

                turtle.forward()
            end
        end
    end

    --  We were able to move, take 2nd position

    local loc2 = vector.new(gps.locate(2, false))


    --  Go back to starting position to stay location-safe
    turtle.back()

    --  Now undo the turning in oder to stay orientation-safe
    movement.turnRight(turns % 4)

    local currentOrientation = directionOf(loc1, loc2)


    --  This allows us to make sure that we do not go out of bounds in case we started off facing the east,
    --  turned to the left in the process of moving and then would end up with a direction-value of
    --  1 - 2, which is negative and not assigned
    while currentOrientation < turns do
        currentOrientation = currentOrientation + 4
    end

    return true, directionStringOf(currentOrientation - turns)
end

--similar to slotSafe, this function allows for the execution of direction-altering operations
-- without affecting the orientation of the mining turtle
function directionSafe(fun, breakBlocks)
    local doneA, orientationA = getOrientation(breakBlocks)

    if not doneA then
        logging.logWithLevel("directions#directionSafe Could not get 1st position", loglevel.error)
        return false, nil
    end

    local ret = fun()

    local doneB, orientationB = getOrientation(breakBlocks)

    if not doneB then
        logging.logWithLevel("directions#directionSafe Could not get 2nd position", loglevel.error)
        return false, nil
    end

    movement.turnLeft(math.abs(directionIntOf(orientationB) - directionIntOf(orientationA)))

    return true, ret
end
