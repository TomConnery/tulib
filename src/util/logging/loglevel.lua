--
-- Created by IntelliJ IDEA.
-- User: Leon
-- Date: 09.09.2018
-- Time: 15:06
-- To change this template use File | Settings | File Templates.
--

if _G.misc == nil then
    os.loadAPI("util/misc.lua")
end



misc.loadAPIs({
    "util/logging/logging.lua",
})


------------------------------
-- variables




--- DEPRECATED returns the respective string associated with the provided value
function loglevelStringOf(i)
    if i > #loglevelStrings then
        logging.logWithLevel("The passed integer could not be mapped to a string", trace)
        return nil
    else
        return loglevelStrings[i+1]
    end
end

