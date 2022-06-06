require 'cairo'

--guage DATA
 gauge = {
    name='acpitemp',               arg='',                  max_value=100,
    x=100,                          y=100,
    txt_weight=1,                  txt_size=12.0,
    txt_fg_colour=0x696969,        txt_fg_alpha=1.0,

 }
 
 -------------------------------------------------------------------------------
--                                                                 rgb_to_r_g_b
-- converts color in hexa to decimal
--
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-------------------------------------------------------------------------------
--                                                            angle_to_position
-- convert degree to rad and rotate (0 degree is top/north)
--
function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ( ( pos * (2 * math.pi / 360) ) - (math.pi / 2) )
end
-------------------------------------------------------------------------------
--                                                             draw_gauge_ring_t
-- displays gauges
--
function draw_gauge_ring_t(display, data, value)
    local function temp_colour(value)
		if value >= 65 then
			return '0xff0000'
		elseif value < 65 then
			return '0xffffff'
		end
	end
    local max_value = data['max_value']
    local x, y = data['x'], data['y']
    local txt_radius = data['txt_radius']
    local txt_weight, txt_size = data['txt_weight'], data['txt_size']
    local txt_fg_colour, txt_fg_alpha = temp_colour(value), data['txt_fg_alpha']
    string = tostring(value)..'°C'
    cairo_select_font_face (display, "zekton", CAIRO_FONT_SLANT_NORMAL, txt_weight)
    cairo_set_font_size (display, txt_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(txt_fg_colour, txt_fg_alpha))
    cairo_move_to (display, x, y)
    cairo_show_text (display, string)
    cairo_stroke (display)


end
-------------------------------------------------------------------------------
--                                                              draw_gauge_ring
-- displays gauges
--

-------------------------------------------------------------------------------
--                                                               go_gauge_rings
-- loads data and displays gauges
--
function go_gauge_rings(display)

    local function load_gauge_rings_1(display, data)
        local str, value = '', 0
        if data['name'] == 'acpitemp' then
			str = '${if_existing /sys/class/thermal/thermal_zone0/temp}${eval ${acpitemp}}${else}0${endif}'
        else 
			str = string.format('${%s %s}',data['name'], data['arg'])
        end
        str = conky_parse(str)
        value = tonumber(str)
        draw_gauge_ring_t(display, data, value)
    end    
--    for i in pairs(gauge) do
        load_gauge_rings_1(display, gauge)
--    end
--	load_gauge_rings(display, gauge)
end

-------------------------------------------------------------------------------
--                                                                         MAIN
function conky_main()
    if conky_window == nil then 
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)
    
    local updates = conky_parse('${updates}')
    update_num = tonumber(updates)
    
    if update_num > 5 then
        go_gauge_rings(display)
    end

    cairo_surface_destroy(cs)
    cairo_destroy(display)

end


