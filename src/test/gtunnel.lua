os.loadAPI("util/misc.lua")

misc.loadAPIs({
    "util/fuel.lua",
    "util/movement.lua",
    "util/logging/logging.lua",
    "util/logging/loglevel.lua"
})

------------------------------------
-- variables

local slotcount = 16

------------------------------------







--clean extraction
misc.slotSafe(setupAndWork)





function newRound(rounds)
    while (rounds ~= 0)
    do
        if not (sufficientFuel()) then

            break
        end
    end
end


function setupAndWork()
end


function isChestBehind()
    movement.turnLeft(2)
    local success, props = turtle.inspect()

    if success then
        if props["name"]:find("chest") then

        else
        end
    else
    end
end


function returnHome()
end


function sufficientFuel()
end

function fuelValueOfSlot(i)
end




