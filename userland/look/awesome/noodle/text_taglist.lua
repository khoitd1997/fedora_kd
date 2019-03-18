local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local naughty = require("naughty")
local capi = {screen = screen, client = client}

local helpers = require("helpers")

local ntags = 10
local s = awful.screen.focused()
local tag_text = {}

local cairo = require("lgi").cairo

-- Create textboxes and set their buttons
-- for i = 1, ntags do
--     table.insert(tag_text, wibox.widget.textbox())
--     tag_text[i]:buttons(
--         gears.table.join(
--             -- Left click - Tag back and forth
--             awful.button(
--                 {},
--                 1,
--                 function()
--                     local current_tag = s.selected_tag
--                     local clicked_tag = s.tags[i]
--                     if clicked_tag == current_tag then
--                         awful.tag.history.restore()
--                     else
--                         clicked_tag:view_only()
--                     end
--                     -- naughty.notify({ text = tostring(i) })
--                 end
--             ),
--             -- Right click - Move focused client to tag
--             awful.button(
--                 {},
--                 3,
--                 function()
--                     local clicked_tag = s.tags[i]
--                     if client.focus then
--                         client.focus:move_to_tag(clicked_tag)
--                     end
--                 end
--             )
--         )
--     )
--     tag_text[i].font = beautiful.taglist_text_font
--     -- So that glyphs of different width always take up the same space in the taglist
--     tag_text[i].forced_width = dpi(25)
--     tag_text[i].align = "center"
--     tag_text[i].valign = "center"
-- end

for i = 1, ntags do
    table.insert(
        tag_text,
        wibox.widget {
            wibox.widget.textbox(),
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(2)
        }
    )
    local currText = tag_text[i].children[1]
    currText:buttons(
        gears.table.join(
            -- Left click - Tag back and forth
            awful.button(
                {},
                1,
                function()
                    local current_tag = s.selected_tag
                    local clicked_tag = s.tags[i]
                    if clicked_tag == current_tag then
                        awful.tag.history.restore()
                    else
                        clicked_tag:view_only()
                    end
                    -- naughty.notify({ text = tostring(i) })
                end
            ),
            -- Right click - Move focused client to tag
            awful.button(
                {},
                3,
                function()
                    local clicked_tag = s.tags[i]
                    if client.focus then
                        client.focus:move_to_tag(clicked_tag)
                    end
                end
            )
        )
    )
    currText.font = beautiful.taglist_text_font
    -- So that glyphs of different width always take up the same space in the taglist
    currText.forced_width = dpi(25)
    currText.align = "center"
    currText.valign = "center"
end

local text_taglist =
    wibox.widget {
    tag_text[1],
    tag_text[2],
    tag_text[3],
    tag_text[4],
    tag_text[5],
    tag_text[6],
    tag_text[7],
    tag_text[8],
    tag_text[9],
    tag_text[10],
    spacing = dpi(3),
    layout = wibox.layout.fixed.horizontal
}

function update_widget()
    for i = 1, ntags do
        local tag_clients
        local currText = tag_text[i].children[1]

        if s.tags[i] then
            tag_clients = s.tags[i]:clients()
        end

        gears.debug.print_warning("Total children " .. tostring(#(tag_text[i].children)))
        while (#(tag_text[i].children) > 1) do
            local ret = tag_text[i]:remove(2)
        end

        if tag_clients and #tag_clients > 0 then
            local layoutIndex = 2
            if (i == 3) then
                gears.debug.print_warning("THis is 3")
                gears.debug.print_warning("Total children after remove " .. tostring(#(tag_text[i].children)))
            end
            for client_id = 1, #tag_clients do
                currClient = tag_clients[client_id]
                local clientSurface = gears.surface(currClient.icon)
                local icon =
                    cairo.ImageSurface.create(
                    cairo.Format.ARGB32,
                    clientSurface:get_width(),
                    clientSurface:get_height()
                )
                local cr = cairo.Context(icon)
                cr:set_source_surface(clientSurface, 0, 0)
                cr:paint()

                -- gears.debug.print_warning(currClient.class)
                if (#tag_clients > #(tag_text[i].children) - 1) then
                    local newImage = wibox.widget.imagebox()
                    newImage.image = icon
                    newImage.resize = true
                    newImage.forced_height = dpi(25)
                    newImage.forced_width = dpi(25)
                    tag_text[i]:add(wibox.container.margin(newImage, 0, 0, dpi(6)))
                else
                    tag_text[i].children[layoutIndex].widget.image = icon
                    tag_text[i].children[layoutIndex].visible = true
                end
                layoutIndex = layoutIndex + 1
            end
            currText.markup = helpers.colorize_text(tostring(i), beautiful.taglist_text_color_empty[i])
            currText.visible = true
        else
            -- tag_text[i][1].opacity = 0.5
            -- tag_text[i][1].markup =
            currText.markup = helpers.colorize_text(tostring(i), beautiful.taglist_text_color_empty[i])
            currText.visible = false
        end

        if s.tags[i] and s.tags[i].selected then
            -- tag_text[i].opacity = 0.5
            currText.markup = helpers.colorize_text(tostring(i), beautiful.taglist_text_color_focused[i])
            currText.visible = true
        elseif s.tags[i] and s.tags[i].urgent then
            currText.markup = helpers.colorize_text(tostring(i), beautiful.taglist_text_color_urgent[i])
            currText.visible = true
        else
        end
    end
end

client.connect_signal(
    "unmanage",
    function(c)
        gears.debug.print_warning("Client is unmanaged")
        update_widget()
    end
)
client.connect_signal(
    "manage",
    function(c)
        update_widget()
    end
)
client.connect_signal(
    "untagged",
    function(c)
        gears.debug.print_warning("Client is untagged")
        update_widget()
    end
)
client.connect_signal(
    "tagged",
    function(c)
        update_widget()
    end
)
client.connect_signal(
    "screen",
    function(c)
        update_widget()
    end
)
awful.tag.attached_connect_signal(
    s,
    "property::selected",
    function()
        update_widget()
    end
)
awful.tag.attached_connect_signal(
    s,
    "property::hide",
    function()
        update_widget()
    end
)
awful.tag.attached_connect_signal(
    s,
    "property::activated",
    function()
        update_widget()
    end
)
awful.tag.attached_connect_signal(
    s,
    "property::screen",
    function()
        update_widget()
    end
)
awful.tag.attached_connect_signal(
    s,
    "property::index",
    function()
        update_widget()
    end
)
awful.tag.attached_connect_signal(
    s,
    "property::urgent",
    function()
        update_widget()
    end
)
awful.tag.attached_connect_signal(
    s,
    "tagged",
    function(c)
        update_widget()
    end
)
awful.tag.attached_connect_signal(
    s,
    "untagged",
    function(c)
        update_widget()
    end
)

return text_taglist
