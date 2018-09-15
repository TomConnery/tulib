--
-- Created by IntelliJ IDEA.
-- User: Leon
-- Date: 13.09.2018
-- Time: 16:12
-- To change this template use File | Settings | File Templates.
--


print("Tulib initialization starting")


--------------------------------------------
--------------------------------------------
--- type-checking util functions
--------------------------------------------

_G.isString = function(var)
    return type(var) == "string"
end

_G.isTable = function(var)
    return type(var) == "table"
end

_G.isBoolean = function(var)
    return type(var) == "boolean"
end

_G.isFunction = function(var)
    return type(var) == "function"
end

_G.isNil = function(var)
    return type(var) == "nil"
end

_G.isNumber = function(var)
    return type(var) == "number"
end



--------------------------------------------
--------------------------------------------
--------------------------------------------







--------------------------------------------
--------------------------------------------
--- set up logging via fake-import
--------------------------------------------

_G.logging = {
    logginglevel = 0,

    --- logs a message if it is log-worthy and raises an error
    logAndError = function(msg, level)
        logging.log(msg, level)
        error(msg)
    end,
    logWithLevel = function(msg, level)
        if loglevel.isLoglevel(level) then
            if level.severity >= logginglevel then
                log(level.getMessagePrefix() .. ": " .. msg)
            end
        else
            logging.log("Provided loglevel " .. level .. " is not specified ", loglevel.warning)
        end
    end,
    log = function(msg)
        print(msg)
    end,
}









_G.loglevel = {
    trace = {
        getName = function()
            return "trace"
        end,
        severity = 0,
        getMessagePrefix = function()
            return "TRACE"
        end
    },
    debug = {
        getName = function()
            return "debug"
        end,
        severity = 10,
        getMessagePrefix = function()
            return "DEBUG"
        end
    },
    info = {
        getName = function()
            return "info"
        end,
        severity = 20,
        getMessagePrefix = function()
            return "INFO"
        end
    },
    warning = {
        getName = function()
            return "warning"
        end,
        severity = 30,
        getMessagePrefix = function()
            return "WARNING"
        end
    },
    error = {
        getName = function()
            return "error"
        end,
        severity = 40,
        getMessagePrefix = function()
            return "ERROR"
        end
    },
    critical = {
        getName = function()
            return "critical"
        end,
        severity = 50,
        getMessagePrefix = function()
            return "CRITICAL"
        end
    },
    loglevels = {
        trace,
        debug,
        info,
        warning,
        error,
        critical
    },


    --- returns true if and only if the provided integer can be mapped to a loglevel
    isLoglevel = function(i)

        for _, loglevel in ipairs(loglevels) do
            if i == loglevel.severity then
                return true
            end
        end
        return false
    end
}

--- fills logging with the loglevel-specific functions
for _, v in ipairs(loglevel.loglevels) do
    logging[v.getName()] = function(msg)
        logging.logWithLevel(msg, v)
    end
end

--------------------------------------------
--------------------------------------------
--------------------------------------------




--------------------------------------------
--------------------------------------------
---os.load altering
--------------------------------------------

---global-wrapper for os.loadAPI
_G.loadAPI = function(modules)
    return os.loadAPI(modules)
end



---dependencies is a module-name based wrapper for imports
_G.dependencies = function(deps)

end





imported = {}


--- checks whether a provided string has the provided suffix
function hasSuffix(str, suffix)
    if not isString(str) then
        logging.error("hasSuffix can only operate on strings (provided types were " .. type(str) .. ", " .. type(suffix) .. ")")
    end

    local ending = str.sub(-suffix.len())

    return ending == suffix
end


--- returns the api name of the passed path
function apiStringOf(path)

    if not isString(path) or isTable(path) then
        logging.error("apiStringOf only takes strings or tables filled with strings (was " .. type(path) .. ")")
    end

    if isString(path) then
        path = { path }
    end

    local ret = {}

    local ending = ".lua"

    for _, p in ipairs(path) do

        if isString(p) then

            if not hasSuffix(p, ending) then
                logging.error("apiStringOf received a path which does not have a proper suffix (" .. ending .. ")")
                ret[p] = nil
            else
                if not p.find("/") then
                    ret[p] = p.sub(#p - p.find(ending))
                else
                    local found = false

                    for i = #p, not found, -1 do

                        if p[i] == "/" then
                            found = true
                        end

                    end
                end
            end
        else
            logging.error("apiStringOf received a table which was populated with a non-string value (was " .. type(p) .. " )")
        end
    end
end

--- this function overrides the defualt os.loadAPI method wiht a new function which helps with implementing post-load
--- hooks
function overrideDefaultLoad(path)
    os.legacyLoadAPI = os.loadAPI

    os.loadAPI = function()

        --        Obligatory type check
        if not isString(path) or not isTable(path) then
            logging.error("the parameter passed to os.loadAPI needs to be either string or table, was ".. type(path))
            return false
        end

        --      enable iterating via making a single object loopable
        if isString(path) then
            path = { path }
        end


        --      ret is a table filledwith booleans in regards of the success of importing a module each
        local ret = {}


        --      import the modules one by one and store the result in ret in respect of their index

        for i, m in ipairs(path) do
            local success = os.legacyLoadAPI(m)
            ret[i] = success


            --      run post-load hooks
            if success then

                local module = apiStringOf(path[i])

                module = _G[module]

                if module then

                    if module.postLoad and isFunction(module.postLoad) then

                        module.postLoad()
                    end

                end

            end
        end

        return ret
    end
end


--- checks if a library has already been loaded
function isImported(api)
    for _, value in ipairs(imported) do
        if value == api then
            return true
        end
    end

    return false
end



--------------------------------------------
--------------------------------------------
--------------------------------------------


print("Tulib initialization finished!")





