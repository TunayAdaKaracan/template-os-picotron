-- Included on each created process to handle events
do
    local event_handlers = {}
    local forward = {}

    local mx, my, mb

    local keys = {}
    local frame_keys = {}

    -- Creates an event handler.
    -- name: str -> Event Name
    -- func: function -> Handler Function
    function on_event(name, func)
        if not event_handlers[name] then
            event_handlers[name] = {}
        end
        add(event_handlers[name], func)
    end

    function _process_events()
        frame_keys = {}
        repeat
            local msg = _read_message()

            if not msg then return end

            for _, func in pairs(forward) do
                func(msg)
            end

            if msg.event == "keydown" then
                add(keys, msg.scancode)
                add(frame_keys, msg.scancode)
            elseif msg.event == "keyup" then
                del(keys, msg.scancode)
            elseif msg.event == "mouse" then
                mx = msg.mx
                my = msg.my
                mb = msg.mb
            end

            if event_handlers[msg.event] then
                for _, func in pairs(event_handlers[msg.event]) do
                    func(msg)
                end
            end

        until not msg
    end

    function _subscribe_to_events(func)
        add(forward, func)
    end

    local function contains(t, val)
        for _, tval in pairs(t) do
            if tval == val then return true end
        end
        return false
    end

    function key(scancode)
        return contains(keys, scancode)
    end

    function keyp(scancode)
        return contains(frame_keys, scancode)
    end

    function mouse()
        return mx, my, mb
    end
end