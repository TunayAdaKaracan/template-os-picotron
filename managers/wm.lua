function _init()
    init_screen(480, 270)
    _subscribe_to_events(function(msg)
        send_message(2, msg)
    end)
end


local timer = time()
local ticker = 0
function _draw()
    cls(3)
    rectfill(0, 0, 99, 99, 22)
    local mx, my = mouse()


    -- _blit_process_video
    -- 1: pid
    -- 2: ?
    -- 3: ?
    -- 4: width or nil -> nil uses 0x5478
    -- 5: height or nill -> nil uses 0x547a
    -- 6: dest x
    -- 7: dest y
    -- returns: nil or ?
    -- if not nil then there is a problem
    _blit_process_video(2, 0, 0, nil, nil, 100, 0)
    pset(mx, my, 15)
end

function _update()
    if time() - timer > 1 then
	printh(ticker)
	ticker = 0
	timer = time()
    else
	ticker += 1
    end
end