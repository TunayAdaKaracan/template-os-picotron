
if _init then
    _init()
end


if not _draw and not _update then return end

local should_close = false

while not should_close do
    _process_events()

    poke(0x547f, peek(0x547f) | 0x2)

    if _update then
        _update()
    end

    if _draw then
        _draw()
    end

    flip(0x0)
end