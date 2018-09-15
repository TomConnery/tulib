if _G.misc == nil then
    os.loadAPI("util/misc.lua")
end

misc.loadAPIs({
    "util/movement/directions.lua"
})

local _, var = directions.getOrientation(true)

print(var)
