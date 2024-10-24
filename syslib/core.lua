do
    -- returns name, extension
    function get_prog_name(path)
        local parts = split(path, "/", false)
        local parts = split(parts[#parts], ".", false)
        return parts[1], parts[2]
    end

    function create_process(path, env)
        local name, ext = get_prog_name(path)

        if ext == ".p64" or ext == ".p64.png" or ext == ".p64.rom" then
            path ..="/main.lua"
        end

        local segs = split(path,"/",false)
        local program_path = string.sub(path, 1, -#segs[#segs] - 2)

        local source = [[
            do
                local core_lib = load(fetch("/system/syslib/core.lua"))
                if not core_lib then
                    printh("CAN'T INCLUDE CORE LIB")
                end
                core_lib()
            end

            require("/system/syslib/events.lua")
            require("/system/syslib/screen.lua")

            function env()
                return]].._pod(env or {}, 0x0)..[[
            end

            cd("]]..program_path..[[")

            require("]]..path..[[")

            require("/system/syslib/loop.lua")
        ]]

        return _create_process_from_code(source, name.."."..ext)
    end

    function http(url, timeout, method)
        local method = method or "GET"
        if method == "GET" then
            local job_id, err = _fetch_remote(url)
            if (err) return nil, err

            local start = time()
            while time() - start < timeout do
                local result, meta, hash_part, err = _fetch_remote_result(job_id)
                if err then
                    return nil, err
                elseif result then
                    return  result, meta, hash_part
                end
                flip(0x1)
            end
            return nil, "timeout"
        end
    end

    function fetch(path)
        -- TODO: anywhen
        local ret, meta = _fetch_local(path)
        return ret, meta
    end

    -- Loads a lua file as an function, runs it and returns whatever that file returns
    -- Usage:
    -- Relatives
    -- require("json.lua")
    -- require("./hello.lua")
    -- System Libs:
    -- require("json")
    function require(filename)
        local path = fullpath(filename)
        if not fetch(path) then
            -- possible lib
            if fetch("/system/lib/"..filename) then
                path = "/system/lib/"..filename
            elseif fetch("/appdata/lib/"..filename) then
                path = "/appdata/lib/"..filename
            else
                -- TODO: Can not load the file
            end
        end

        local func, err = load(fetch(path), "@"..filename, "t", _ENV)

        if err then
            --TODO: Syntax err handling
        end

        return func()
    end
end