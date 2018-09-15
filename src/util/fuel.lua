--
-- Created by IntelliJ IDEA.
-- User: Leon
-- Date: 09.09.2018
-- Time: 14:24
-- To change this template use File | Settings | File Templates.
--

if _G.misc == nil then
    os.loadAPI("util/misc.lua")
end


misc.loadAPIs({
    "util/logging/logging.lua"
})


--checks whether the rutle is fueled enough to move n blocks and attempts to refuel the turtle if this is not the case
function isFueledOrRefuel(n)

    if type(n) ~= "number" then
        logging.logWithLevel("fuel#isFueledOrRefuel only accepts numbers as parameter", loglevel.error)
        return false
    end

    if not (turtle.getFuelLevel() >= n) then
        local isFueled, slots = hasFuel()
        if isFueled then
            local function safe()
                turtle.select(slots[1])
                turtle.refuel(1)
            end

            misc.slotSafe(safe)

            return true

        else
            logging.logWithLevel("Tried to refuel turtle but no fuel was found in inventory", loglevel.error)
            return false
        end
    else
        return true
    end
end


--checks whether the turtle has any fuel left in its inventory and returns
-- the respective slots if it does as the 2nd return value
function hasFuel()
    local ret = getFuelSlots()
    return #ret > 0, ret
end


--returns an array holding all slots which currently hold combustible items
function getFuelSlots()
    local fuelSlots = {}

    for i = 1, 16 do
        if slotHoldsCombustible(i) then
            fuelSlots[#fuelSlots+1] = i
        end
    end

    return fuelSlots
end


--checks whether a slot holds a combustible item
function slotHoldsCombustible(slot)

    local function holdsCombustible()
        turtle.select(slot)
        return turtle.refuel(0)
    end

    return misc.slotSafe(holdsCombustible)
end

