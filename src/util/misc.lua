--
-- Created by IntelliJ IDEA.
-- User: Leon
-- Date: 09.09.2018
-- Time: 14:24
-- To change this template use File | Settings | File Templates.
--



--imported = {}

----- DEPRECATED checks if a library has already been loaded
--function isLoaded(api)
--    for _, value in ipairs(imported) do
--        if value == api then
--            return true
--        end
--    end
--
--    return false
--end


----- DEPRECATED array wrapper for os.loadAPI
--function loadAPIs(apis)
--
--    if not (type(apis) == "table" or type(apis) == "string") then
--       print("ERROR: Called util.misc.loadAPIs with wrong parameter type (has to be table/string, was "..type(apis).." )")
--    else
--        if type(apis) == "string" then
--            apis = {apis}
--        end
--        for _,api in pairs(apis) do
--            if not isLoaded(api) then
--                imported[#imported +1] = api
--                os.loadAPI(api)
--            end
--        end
--    end
--end



--loadAPIs({
--    "util/vardump.lua"
--})




---allows for safe execution of functions which affect the selection of slots
function slotSafe(fun)

    local current = turtle.getSelectedSlot()

    local ret = fun()

    turtle.select(current)

    return ret
end

