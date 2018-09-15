os.loadAPI("util/misc.lua")
misc.loadAPIs({

"util/fuel.lua",
"util/vardump.lua",

})

local args = {...}

print("Fuel level: " .. turtle.getFuelLevel())
print("Has fuel: " .. tostring(fuel.hasFuel()))
print("Fuel slots: " .. vardump.to_string(fuel.getFuelSlots()))
print("Using fuel.isFueledOrRefuel with param " .. tostring(args[1]))
fuel.isFueledOrRefuel(tonumber(args[1]))
print("Fuel level: " .. turtle.getFuelLevel())

