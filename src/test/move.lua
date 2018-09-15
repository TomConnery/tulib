os.loadAPI("util/misc.lua")

misc.loadAPIs({
    "util/movement/movement.lua"
})

print(movement.moveToFirstUnoccupied())
