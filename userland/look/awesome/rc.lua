local theme_name = "skyfall"
local bar_theme_name = "skyfall"

modkey = "Mod4"

--------------------------------------------------------------------------------

-- Jit
--pcall(function() jit.on() end)
local home_dir = os.getenv("HOME")

-- Theme handling library
local beautiful = require("beautiful")
-- Themes define colours, icons, font and wallpapers.
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
beautiful.init(theme_dir .. theme_name .. "/theme.lua")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Default notification library
local naughty = require("naughty")
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")

-- {{{ Initialize stuff

-- Basic (required)
local helpers = require("helpers")
local titlebars = require("titlebars")

-- Extra features
local bars = require("bar_themes." .. bar_theme_name)
local tag_notifications = require("noodle.tag_notifications")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end
-- }}}

-- {{{ Variable definitions
terminal = "gnome-terminal"
-- Some terminals do not respect spawn callbacks
floating_terminal = "gnome-terminal -c fst" -- clients with class "fst" are set to be floating (check awful.rules below)
browser = "firefox"
filemanager = "nemo"
tmux = terminal .. " -e tmux new "
editor = "vim"
editor_cmd = terminal .. " -e " .. editor .. " "

-- Get screen geometry
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- I only ever use these 3
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Notifications

-- Icon size
naughty.config.defaults["icon_size"] = beautiful.notification_icon_size

-- Timeouts
naughty.config.defaults.timeout = 5
naughty.config.presets.low.timeout = 2
naughty.config.presets.critical.timeout = 12

-- Apply theme variables
naughty.config.padding = beautiful.notification_padding
naughty.config.spacing = beautiful.notification_spacing
naughty.config.defaults.margin = beautiful.notification_margin
naughty.config.defaults.border_width = beautiful.notification_border_width

naughty.config.presets.normal = {
    font = beautiful.notification_font,
    fg = beautiful.notification_fg,
    bg = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin = beautiful.notification_margin,
    position = beautiful.notification_position
}

naughty.config.presets.low = {
    font = beautiful.notification_font,
    fg = beautiful.notification_fg,
    bg = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin = beautiful.notification_margin,
    position = beautiful.notification_position
}

naughty.config.presets.ok = naughty.config.presets.low
naughty.config.presets.info = naughty.config.presets.low
naughty.config.presets.warn = naughty.config.presets.normal

naughty.config.presets.critical = {
    font = beautiful.notification_font,
    fg = beautiful.notification_crit_fg,
    bg = beautiful.notification_crit_bg,
    border_width = beautiful.notification_border_width,
    margin = beautiful.notification_margin,
    position = beautiful.notification_position
}

-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    {
        "hotkeys",
        function()
            return false, hotkeys_popup.show_help
        end,
        beautiful.keyboard_icon
    },
    {"restart", awesome.restart, beautiful.reboot_icon},
    {
        "quit",
        function()
            exit_screen_show()
        end,
        beautiful.poweroff_icon
    }
}

mymainmenu =
    awful.menu(
    {
        items = {
            {"awesome", myawesomemenu, beautiful.home_icon},
            {"firefox", browser, beautiful.firefox_icon},
            {"terminal", terminal, beautiful.terminal_icon},
            {"files", filemanager, beautiful.files_icon},
            {"search", "rofi -show combi", beautiful.search_icon},
            {
                "discord",
                function()
                    local matcher = function(c)
                        return awful.rules.match(c, {class = "discord"})
                    end
                    awful.client.run_or_raise("discord", matcher)
                end,
                beautiful.discord_icon
            },
            {
                "telegram",
                function()
                    local matcher = function(c)
                        return awful.rules.match(c, {class = "TelegramDesktop"})
                    end
                    awful.client.run_or_raise("telegram", matcher)
                end,
                beautiful.telegram_icon
            },
            {
                "mail",
                function()
                    local matcher = function(c)
                        return awful.rules.match(c, {class = "Thunderbird"})
                    end
                    awful.client.run_or_raise("thunderbird", matcher)
                end,
                beautiful.mail_icon
            },
            {
                "gimp",
                function()
                    local matcher = function(c)
                        return awful.rules.match(c, {class = "Gimp"})
                    end
                    awful.client.run_or_raise("gimp", matcher)
                end,
                beautiful.gimp_icon
            },
            {"appearance", "lxappearance", beautiful.appearance_icon}
        }
    }
)

mylauncher =
    awful.widget.launcher(
    {
        image = beautiful.awesome_icon,
        menu = mymainmenu
    }
)
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = (s)
        end

        -- Method 1: Built in function
        gears.wallpaper.maximized(wallpaper, s, true)

    -- Method 2: Set theme's wallpaper with feh
    -- awful.spawn.with_shell("feh --bg-fill " .. "/usr/share/user_file/TCP118v1_by_Tiziano_Consonni.jpg")

    -- Method 3: Set last wallpaper with feh
    -- awful.spawn.with_shell(os.getenv("HOME") .. "/.fehbg")
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
    function(s)
        -- Wallpaper
        set_wallpaper(s)

        -- Each screen has its own tag table.
        -- Tag layouts
        local l = awful.layout.suit -- Alias to save time :)
        -- local layouts = { l.max, l.floating, l.max, l.max , l.tile,
        --     l.max, l.max, l.max, l.floating, l.tile}
        local layouts = {
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile
        }

        -- Tag names
        local tagnames = beautiful.tagnames or {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}

        -- Create tags
        awful.tag.add(
            tagnames[1],
            {
                layout = layouts[1],
                screen = s,
                selected = true
            }
        )
        awful.tag.add(
            tagnames[2],
            {
                layout = layouts[2],
                screen = s
            }
        )
        awful.tag.add(
            tagnames[3],
            {
                layout = layouts[3],
                screen = s
            }
        )
        awful.tag.add(
            tagnames[4],
            {
                layout = layouts[4],
                master_width_factor = 0.6,
                screen = s
            }
        )
        awful.tag.add(
            tagnames[5],
            {
                layout = layouts[5],
                master_width_factor = 0.65,
                screen = s
            }
        )
        awful.tag.add(
            tagnames[6],
            {
                layout = layouts[6],
                screen = s
            }
        )
        awful.tag.add(
            tagnames[7],
            {
                layout = layouts[7],
                screen = s
            }
        )
        awful.tag.add(
            tagnames[8],
            {
                layout = layouts[8],
                screen = s
            }
        )
        awful.tag.add(
            tagnames[9],
            {
                layout = layouts[9],
                screen = s
            }
        )
        awful.tag.add(
            tagnames[10],
            {
                layout = layouts[10],
                screen = s
            }
        )

        -- Create all tags at once (without seperate configuration for each tag)
        -- awful.tag(tagnames, s, layouts)
    end
)

globalkeys =
    gears.table.join(
    awful.key({modkey, "Shift"}, "s", hotkeys_popup.show_help, {description = "show help", group = "awesome"}),
    awful.key({modkey}, "Left", awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({modkey}, "Right", awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({modkey}, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),
    awful.key(
        {modkey},
        "l",
        function()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key(
        {modkey},
        "h",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key(
        {modkey},
        "w",
        function()
            mymainmenu:show()
        end,
        {description = "show main menu", group = "awesome"}
    ),
    -- Layout manipulation
    awful.key(
        {modkey, "Shift"},
        "j",
        function()
            awful.client.swap.byidx(1)
        end,
        {description = "swap with next client by index", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "k",
        function()
            awful.client.swap.byidx(-1)
        end,
        {description = "swap with previous client by index", group = "client"}
    ),
    awful.key(
        {modkey, "Control"},
        "j",
        function()
            awful.screen.focus_relative(1)
        end,
        {description = "focus the next screen", group = "screen"}
    ),
    awful.key(
        {modkey, "Control"},
        "k",
        function()
            awful.screen.focus_relative(-1)
        end,
        {description = "focus the previous screen", group = "screen"}
    ),
    awful.key({modkey}, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
    awful.key(
        {modkey},
        "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}
    ),
    -- Standard program
    awful.key(
        {modkey},
        "Return",
        function()
            awful.spawn(terminal)
        end,
        {description = "open a terminal", group = "launcher"}
    ),
    awful.key(
        {modkey},
        "b",
        function()
            awful.util.spawn("google-chrome")
        end,
        {description = "open google chrome", group = "launcher"}
    ),
    awful.key({modkey, "Control"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    -- awful.key({modkey, "Shift"}, "q", awesome.quit, {description = "quit awesome", group = "awesome"}),
    -- awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    --           {description = "increase master width factor", group = "layout"}),
    -- awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    --           {description = "decrease master width factor", group = "layout"}),

    awful.key(
        {modkey, "Shift"},
        "h",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"},
        "h",
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {description = "increase the number of columns", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"},
        "l",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}
    ),
    awful.key(
        {modkey},
        "space",
        function()
            awful.layout.inc(1)
        end,
        {description = "select next", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "space",
        function()
            awful.layout.inc(-1)
        end,
        {description = "select previous", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"},
        "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        {description = "restore minimized", group = "client"}
    ),
    -- rofi
    awful.key(
        {modkey},
        "r",
        function()
            awful.util.spawn("rofi -show combi -config ~/.config/rofi/rofi_config")
        end,
        {description = "run general rofi prompt", group = "launcher"}
    ),
    awful.key(
        {modkey},
        "f",
        function()
            awful.util.spawn(
                "rofi -matching normal -config ~/.config/rofi/rofi_config -show find -modi find:~/.config/rofi/rofi_file_open.sh"
            )
        end,
        {description = "run file search rofi prompt", group = "launcher"}
    ),
    awful.key(
        {modkey},
        "s",
        function()
            awful.util.spawn(home_dir .. "/.config/rofi/rofi_web_search.sh")
        end,
        {description = "run web search for rofi", group = "launcher"}
    ),
    awful.key(
        {modkey},
        "x",
        function()
            awful.prompt.run {
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}
    ),
    -- Menubar
    awful.key(
        {modkey},
        "p",
        function()
            menubar.show()
        end,
        {description = "show the menubar", group = "launcher"}
    ),
    awful.key(
        {modkey},
        "m",
        function(c)
            awful.util.spawn("code")
        end,
        {description = "launch vscode", group = "client"}
    )
)

clientkeys =
    gears.table.join(
    awful.key(
        {},
        "#122",
        function()
            awful.util.spawn("amixer -D pulse sset Master 5%-")
        end
    ),
    awful.key(
        {},
        "#123",
        function()
            awful.util.spawn("amixer -D pulse sset Master 5%+")
        end
    ),
    awful.key(
        {},
        "#232",
        function()
            awful.util.spawn("xbacklight -dec 10")
        end
    ),
    awful.key(
        {},
        "#233",
        function()
            awful.util.spawn("xbacklight -inc 10")
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    ),
    awful.key(
        {modkey},
        "q",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
    ),
    awful.key(
        {modkey, "Control"},
        "space",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
    ),
    awful.key(
        {modkey, "Control"},
        "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
    ),
    awful.key(
        {modkey},
        "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}
    ),
    awful.key(
        {modkey},
        "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
    ),
    awful.key(
        {modkey},
        "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
    ),
    awful.key(
        {modkey, "Control"},
        "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {description = "(un)maximize vertically", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {description = "(un)maximize horizontally", group = "client"}
    )
)

for i = 1, 9 do
    globalkeys =
        gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key(
            {modkey},
            "#" .. i + 9,
            function()
                for s in screen do
                    -- local screen = awful.screen.focused()
                    local tag = s.tags[i]
                    if tag then
                        tag:view_only()
                    end
                end
            end,
            {description = "view tag #" .. i, group = "tag"}
        ),
        -- Toggle tag display.
        awful.key(
            {modkey, "Control"},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),
        -- Move client to tag.
        awful.key(
            {modkey, "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}
        ),
        -- Toggle tag on focused client.
        awful.key(
            {modkey, "Control", "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        )
    )
end

desktopbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function()
            mymainmenu:hide()
            -- sidebar.visible = false
            naughty.destroy_all_notifications()

            local function double_tap()
                uc = awful.client.urgent.get()
                -- If there is no urgent client, go back to last tag
                if uc == nil then
                    awful.tag.history.restore()
                else
                    awful.client.urgent.jumpto()
                end
            end
            helpers.single_double_tap(
                function()
                end,
                double_tap
            )
        end
    ),
    awful.button(
        {},
        3,
        function()
            mymainmenu:toggle()
        end
    ),
    -- Middle button - Toggle start scren
    awful.button(
        {},
        2,
        function()
            start_screen_show()
            -- sidebar.visible = not sidebar.visible
        end
    ),
    -- Scrolling - Switch tags
    awful.button({}, 4, awful.tag.viewprev),
    awful.button({}, 5, awful.tag.viewnext),
    -- Side buttons - Control volume
    awful.button(
        {},
        9,
        function()
            awful.spawn.with_shell("volume-control.sh up")
        end
    ),
    awful.button(
        {},
        8,
        function()
            awful.spawn.with_shell("volume-control.sh down")
        end
    )

    -- Side buttons - Minimize and restore minimized client
    -- awful.button({ }, 8, function()
    --     if client.focus ~= nil then
    --         client.focus.minimized = true
    --     end
    -- end),
    -- awful.button({ }, 9, function()
    --       local c = awful.client.restore()
    --       -- Focus restored client
    --       if c then
    --           client.focus = c
    --           c:raise()
    --       end
    -- end)
)
root.buttons(desktopbuttons)

clientbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

root.keys(globalkeys)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = {"normal", "dialog"}
        },
        properties = {titlebars_enabled = true}
    },
    -- Floating clients
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq" -- Includes session name in class.
            },
            class = {
                "Lxappearance",
                "Nm-connection-editor",
                "File-roller",
                "htop",
                "fst"
            },
            name = {
                "Event Tester" -- xev
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            },
            type = {
                "dialog"
            }
        },
        properties = {floating = false, ontop = false}
    },
    -- Centered clients
    {
        rule_any = {
            type = {
                "dialog"
            },
            class = {
                "discord"
            },
            role = {
                "GtkFileChooserDialog",
                "conversation"
            }
        },
        properties = {},
        callback = function(c)
            awful.placement.centered(c, {honor_workarea = true})
        end
    },
    {
        rule_any = {
            class = {
                "code"
            }
        },
        properties = {maximized_vertical = false, maximized_horizontal = false},
        callback = function(c)
            awful.placement.centered(c, {honor_workarea = true})
        end
    },
    -- "Switch to tag"
    -- These clients make you switch to their tag when they appear
    {
        rule_any = {
            class = {}
        },
        properties = {switchtotag = true}
    },
    -- Titlebars OFF (explicitly)
    -- Titlebars of these clients will be hidden regardless of the theme setting
    {
        rule_any = {
            class = {
                "Gnome-terminal",
                "qutebrowser",
                "Sublime_text",
                "Subl3",
                "Firefox",
                "google-chrome"
            }
        },
        properties = {maximized_vertical = false, maximized_horizontal = false},
        callback = function(c)
            if not beautiful.titlebars_imitate_borders then
                awful.titlebar.hide(c)
            end
        end
    },
    -- Titlebars ON (explicitly)
    -- Titlebars of these clients will be shown regardless of the theme setting
    {
        rule_any = {
            class = {},
            type = {
                "dialog"
            },
            role = {
                "conversation"
            }
        },
        properties = {},
        callback = function(c)
            awful.titlebar.show(c)
        end
    },
    -- Skip taskbar
    {
        rule_any = {
            class = {}
        },
        properties = {skip_taskbar = true}
    },
    -- File managers
    {
        rule_any = {
            class = {
                "Nautilus",
                "Dolphin",
                "Nemo",
                "Thunar"
            }
        },
        except_any = {
            type = {"dialog"}
        },
        properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.75}
    },
    -- Rofi configuration
    -- Needed only if option "-normal-window" is used
    {
        rule_any = {
            class = {
                "Rofi"
            }
        },
        properties = {skip_taskbar = true, floating = true, ontop = true, sticky = true},
        callback = function(c)
            awful.placement.centered(c, {honor_workarea = true})
            if not beautiful.titlebars_imitate_borders then
                awful.titlebar.hide(c)
            end
        end
    },
    -- Screenruler
    {
        rule_any = {
            class = {
                "Screenruler"
            }
        },
        properties = {border_width = 0, floating = true, ontop = true},
        callback = function(c)
            awful.titlebar.hide(c)
            awful.placement.centered(c, {honor_workarea = true})
        end
    },
    -- Image viewers
    {
        rule_any = {
            class = {
                "feh",
                "Sxiv"
            }
            -- }, properties = { floating = true },
        },
        properties = {floating = true, width = screen_width * 0.7, height = screen_height * 0.75},
        callback = function(c)
            awful.placement.centered(c, {honor_workarea = true})
        end
    }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set every new window as a slave,
        -- i.e. put it at the end of others instead of setting it master.
        if not awesome.startup then
            awful.client.setslave(c)
        end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Hide titlebars if required by the theme
client.connect_signal(
    "manage",
    function(c)
        if not beautiful.titlebars_enabled then
            awful.titlebar.hide(c)
        end
    end
)

-- If the layout is not floating, every floating client that appears is centered
-- If the layout is floating, and there is no other client visible, center it
client.connect_signal(
    "manage",
    function(c)
        if not awesome.startup then
            if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
                awful.placement.centered(c, {honor_workarea = true})
            else
                if #mouse.screen.clients == 1 then
                    awful.placement.centered(c, {honor_workarea = true})
                end
            end
        end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--        and awful.client.focus.filter(c) then
--        client.focus = c
--    end
--end)

-- Rounded corners
if beautiful.border_radius ~= 0 then
    client.connect_signal(
        "manage",
        function(c, startup)
            if not c.fullscreen then
                c.shape = helpers.rrect(beautiful.border_radius)
            end
        end
    )

    -- Fullscreen clients should not have rounded corners
    client.connect_signal(
        "property::fullscreen",
        function(c)
            if c.fullscreen then
                c.shape = helpers.rect()
            else
                c.shape = helpers.rrect(beautiful.border_radius)
            end
        end
    )
end

-- When a client starts up in fullscreen, resize it to cover the fullscreen a short moment later
-- Fixes wrong geometry when titlebars are enabled
--client.connect_signal("property::fullscreen", function(c)
client.connect_signal(
    "manage",
    function(c)
        if c.fullscreen then
            gears.timer.delayed_call(
                function()
                    if c.valid then
                        c:geometry(c.screen.geometry)
                    end
                end
            )
        end
    end
)

-- Center client when floating property changes
--client.connect_signal("property::floating", function(c)
--awful.placement.centered(c,{honor_workarea=true})
--end)

-- Apply shapes
-- beautiful.notification_shape = helpers.infobubble(beautiful.notification_border_radius)
beautiful.notification_shape = helpers.rrect(beautiful.notification_border_radius)
beautiful.snap_shape = helpers.rrect(beautiful.border_radius * 2)
beautiful.taglist_shape = helpers.rrect(beautiful.taglist_item_roundness)

client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)

-- Set mouse resize mode (live or after)
awful.mouse.resize.set_mode("live")

-- Floating: restore geometry
tag.connect_signal(
    "property::layout",
    function(t)
        for k, c in ipairs(t:clients()) do
            if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
                -- Geometry x = 0 and y = 0 most probably means that the
                -- clients have been spawned in a non floating layout, and thus
                -- they don't have their floating_geometry set properly.
                -- If that is the case, don't change their geometry
                local cgeo = awful.client.property.get(c, "floating_geometry")
                if cgeo ~= nil then
                    if not (cgeo.x == 0 and cgeo.y == 0) then
                        c:geometry(awful.client.property.get(c, "floating_geometry"))
                    end
                end
            --c:geometry(awful.client.property.get(c, 'floating_geometry'))
            end
        end
    end
)

client.connect_signal(
    "manage",
    function(c)
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            awful.client.property.set(c, "floating_geometry", c:geometry())
        end
    end
)

client.connect_signal(
    "property::geometry",
    function(c)
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            awful.client.property.set(c, "floating_geometry", c:geometry())
        end
    end
)

-- Make rofi able to unminimize minimized clients
client.connect_signal(
    "request::activate",
    function(c, context, hints)
        if not awesome.startup then
            if c.minimized then
                c.minimized = false
            end
            awful.ewmh.activate(c, context, hints)
        end
    end
)

-- Disconnect the client ability to request different size and position
-- client.disconnect_signal("request::geometry", awful.ewmh.client_geometry_requests)

-- Battery notifications
-- The signals are sent by a udev rule.

local last_battery_notification_id
awesome.connect_signal(
    "charger_plugged",
    function(c)
        notification =
            naughty.notify(
            {
                title = "Juice status:",
                text = "Your battery is charging!",
                icon = beautiful.battery_charging_icon,
                timeout = 3,
                replaces_id = last_battery_notification_id
            }
        )
        last_battery_notification_id = notification.id
    end
)
awesome.connect_signal(
    "charger_unplugged",
    function(c)
        notification =
            naughty.notify(
            {
                title = "Juice status:",
                text = "Your battery is discharging!",
                icon = beautiful.battery_icon,
                timeout = 3,
                replaces_id = last_battery_notification_id
            }
        )
        last_battery_notification_id = notification.id
    end
)
awesome.connect_signal(
    "battery_full",
    function(c)
        notification =
            naughty.notify(
            {
                title = "Juice status:",
                text = "Full! Your tank is topped up!",
                icon = beautiful.battery_icon,
                timeout = 3,
                replaces_id = last_battery_notification_id
            }
        )
        last_battery_notification_id = notification.id
    end
)
awesome.connect_signal(
    "battery_low",
    function(c)
        notification =
            naughty.notify(
            {
                title = "Juice status:",
                text = "Low. Running out of juice soon!",
                icon = beautiful.battery_icon,
                timeout = 5,
                replaces_id = last_battery_notification_id
            }
        )
        last_battery_notification_id = notification.id
    end
)
awesome.connect_signal(
    "battery_critical",
    function(c)
        notification =
            naughty.notify(
            {
                title = "Juice status:",
                text = "Critical! Where is the cable?!",
                icon = beautiful.battery_icon,
                timeout = 0,
                replaces_id = last_battery_notification_id
            }
        )
        last_battery_notification_id = notification.id
    end
)

-- Startup applications
awful.spawn.with_shell(os.getenv("HOME") .. "/.config/awesome/autostart.sh")
-- }}}
