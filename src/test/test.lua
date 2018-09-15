os.loadAPI("util/misc.lua")
misc.loadAPIs({

"util/vardump.lua",
"util/movement/directions.lua",
"util/fuel.lua",
"util/movement/movement.lua",

})

--print(vardump.to_string(gps.locate(2, true)))
--print(vardump.to_string(peripheral.find("modem")))
--print(directions.isGPSEnabled())
--print(not fuel.isFueledOrRefuel(2))
--movement.turnRight(0)

local p1, p2

p1 = directions.getOrientation(true)


function test()
    movement.turnLeft(3)
end

directions.directionSafe(test, true)

p2 = directions.getOrientation(true)

assert(p2 == p1)
