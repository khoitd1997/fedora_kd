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

-- local tasklist_buttons = gears.table.join(
--                      awful.button({ }, 1,
--                         function (c)
--                             if c == client.focus then
--                                 c.minimized = true
--                             else
--                                 -- Without this, the following
--                                 -- :isvisible() makes no sense
--                                 c.minimized = false
--                                 if not c:isvisible() and c.first_tag then
--                                     c.first_tag:view_only()
--                                 end
--                                 -- This will also un-minimize
--                                 -- the client, if needed
--                                 client.focus = c
--                                 c:raise()
--                             end
--                         end),
--                      -- Middle mouse button closes the window
--                      awful.button({ }, 2, function (c) c:kill() end),
--                      awful.button({ }, 3, function (c) c.minimized = true end),
--                      awful.button({ }, 4, function ()
--                                               awful.client.focus.byidx(-1)
--                                           end),
--                      awful.button({ }, 5, function ()
--                                               awful.client.focus.byidx(1)
--                     end)
-- )
-- }}}

awful.screen.connect_for_each_screen(
    function(s)
        -- Create a system tray widget
        -- s.systray = wibox.widget.systray()

        -- Create a wibox that will only show the tray
        -- Hidden by default. Can be toggled with a keybind.
        -- s.traybox =
        --     wibox({visible = false, ontop = true, shape = helpers.rrect(beautiful.border_radius), type = "dock"})
        -- s.traybox.width = dpi(120)
        -- s.traybox.height = beautiful.wibar_height - beautiful.screen_margin * 4
        -- s.traybox.x = s.geometry.width - beautiful.screen_margin * 2 - s.traybox.width
        -- s.traybox.y = s.geometry.height - s.traybox.height - beautiful.screen_margin * 2
        -- -- s.traybox.y = s.geometry.height - s.traybox.height - s.traybox.height / 2
        -- s.traybox.bg = beautiful.bg_systray
        -- s.traybox:setup {
        --     pad(1),
        --     s.systray,
        --     pad(1),
        --     layout = wibox.layout.align.horizontal
        -- }
        -- s.traybox:buttons(
        --     gears.table.join(
        --         -- Middle click - Hide traybox
        --         awful.button(
        --             {},
        --             2,
        --             function()
        --                 s.traybox.visible = false
        --             end
        --         )
        --     )
        -- )
        -- -- Hide traybox when mouse leaves
        -- s.traybox:connect_signal(
        --     "mouse::leave",
        --     function()
        --         s.traybox.visible = false
        --     end
        -- )

        -- Create a taglist widget
        -- s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

        -- Create an icon taglist
        -- local icon_taglist = require("noodle.icon_taglist")

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
        -- window_buttons:buttons(
        --     gears.table.join(
        --         awful.button(
        --             {},
        --             2,
        --             function()
        --                 awful.spawn.with_shell("rofi -show windowcd")
        --             end
        --         ),
        --         awful.button(
        --             {},
        --             4,
        --             function()
        --                 awful.client.focus.byidx(-1)
        --             end
        --         ),
        --         awful.button(
        --             {},
        --             5,
        --             function()
        --                 awful.client.focus.byidx(1)
        --             end
        --         )
        --     )
        -- )

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
                -- text_weather,
                spacing = dpi(12),
                layout = wibox.layout.fixed.horizontal
            },
            text_taglist,
            window_buttons,
            -- bottom_systray,
            expand = "none",
            layout = wibox.layout.align.horizontal
        }
    end
)

local s = mouse.screen
-- Show traybox when the mouse touches the rightmost edge of the wibar
-- TODO fix for wibar_position = "top"
traybox_activator =
    wibox(
    {
        x = s.geometry.width - 1,
        y = s.geometry.height - beautiful.wibar_height,
        height = beautiful.wibar_height,
        width = 1,
        opacity = 0,
        visible = true,
        bg = beautiful.wibar_bg
    }
)
traybox_activator:connect_signal(
    "mouse::enter",
    function()
        -- awful.screen.focused().traybox.visible = true
        -- s.traybox.visible = true
    end
)
