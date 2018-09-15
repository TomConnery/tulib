--
-- Created by IntelliJ IDEA.
-- User: Leon
-- Date: 13.09.2018
-- Time: 13:36
-- To change this template use File | Settings | File Templates.
--

if not misc then
    os.loadAPI("util/misc.lua")
end

misc.loadAPIs({
    "util/logging/logging.lua",
    "util/logging/loglevel.lua",

})

---populates the logging-api with specific logging methods
function fillLogging()
    for _, v in ipairs(logelevel.loglevels) do
        logging[v.getName()] = function(msg)
            logging.logWithLevel(msg, v)
        end
    end
end


function init()

    fillLogging()

end



init()

