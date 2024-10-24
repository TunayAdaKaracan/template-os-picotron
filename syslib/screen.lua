-- Handles Screen Stuff Related To FoxOS

do
    local _display
    local _target

    function set_draw_target(d)
        _target = d or _display

        _set_draw_target(_target)
    end

    function get_draw_target()
        return _target
    end

    function set_display(d)
        _display = d
        _map_ram(d, 0x10000)
    end

    function get_display()
        return _display
    end

    function update_screen(w, h)
        set_display(userdata("u8", w, h))
        poke2(0x5478, w)
        poke2(0x547a, h)
        poke2(0x547c, 0)
        set_draw_target()
    end

    function init_screen(w, h)
        pal()
        poke(0x5508, 0x3f)
        poke(0x5509, 0x3f)
        poke(0x5f56, 0x40)
        poke(0x4000, get(_fetch_local("/system/fonts/lil.font")))

        update_screen(w, h)
    end

    function printh(text)
        _printh(tostring(pid()) .. ": " .. text)
    end

    function print(text, x, y, clr)
        _print_p8scii(text, x, y, clr)
    end
end