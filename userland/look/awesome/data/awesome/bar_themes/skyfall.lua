local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local pad = helpers.pad

-- {{{ Widgets
-- Create a wibox for each screen and add it
local taglist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    -- awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button(
        {},
        3,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button(
        {modkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    )
)

awful.screen.connect_for_each_screen(
    function(s)
        -- Create a custom text taglist

        local text_taglist = require("noodle.text_taglist")
        client.connect_signal(
            "manage",
            function(c)
                update_widget()
            end
        )

        local time = wibox.widget.textclock("%H:%M")
        time.align = "center"
        time.valign = "center"
        time.font = "Typicons 11"

        local date = wibox.widget.textclock("%B %d")
        date.align = "center"
        date.valign = "center"
        date.font = "Typicons 11"

        update_interval = 60
        cpu_cores = [[bash -c '
        grep -m 1 'cpu cores' /proc/cpuinfo
        ']]

        local sysload =
            wibox.widget {
            markup = "0.5",
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox
        }

        local load_script = [[
  bash -c "
    cat /proc/loadavg | awk '{printf \"%f\", $1}'
  "]]

        awful.widget.watch(
            load_script,
            update_interval,
            function(widget, stdout)
                local load = stdout
                local strload = ("%.5g"):format(load)
                if load < cpu_cores then
                    sysload.markup = '<span foreground="grey">' .. strload .. "</span>"
                elseif (load < 2 * cpu_cores) then
                    sysload.markup = '<span foreground="orange">' .. strload .. "</span>"
                else
                    sysload.markup = '<span foreground="red">' .. strload .. "</span>"
                end
            end
        )

        local window_buttons =
            wibox.widget {
            wibox.widget.systray(),
            sysload,
            date,
            time,
            {
                -- Padding
                spacing = dpi(6),
                layout = wibox.layout.fixed.horizontal
            },
            spacing = dpi(12),
            layout = wibox.layout.fixed.horizontal
        }

        -- Create the wibox
        s.mywibox =
            awful.wibar(
            {
                position = beautiful.wibar_position,
                screen = s,
                width = beautiful.wibar_width,
                height = beautiful.wibar_height,
                shape = helpers.rrect(beautiful.wibar_border_radius)
            }
        )
        -- Wibar items
        -- Add or remove widgets here
        s.mywibox:setup {
            {
                {
                    -- Some padding
                    layout = wibox.layout.fixed.horizontal
                },
                spacing = dpi(12),
                layout = wibox.layout.fixed.horizontal
            },
            text_taglist,
            window_buttons,
            expand = "none",
            layout = wibox.layout.align.horizontal
        }
    end
)

local s = mouse.screen