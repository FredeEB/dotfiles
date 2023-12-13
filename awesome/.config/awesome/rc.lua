-- Standard awesome library
local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')
-- Widget and layout library
local wibox = require('wibox')
-- Theme handling library
local beautiful = require('beautiful')

beautiful.init(gears.filesystem.get_themes_dir() .. 'default/theme.lua')

local modkey = 'Mod4'
local terminal = os.getenv('TERMINAL') or 'wezterm'
local browser = os.getenv('BROWSER') or 'firefox'

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

-- {{{ Wibar
-- Create a textclock widget
local textclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                'request::activate',
                'tasklist',
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

awful.screen.connect_for_each_screen(function(s)

    awful.tag({ 'a', 's', 'd', 'f', 'z', 'x', 'c', 'v' }, s, awful.layout.layouts[1])
    -- Create a taglist widget
    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.wibox = awful.wibar({ position = 'top', screen = s })

    -- Add widgets to the wibox
    s.wibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.taglist,
        },
        s.tasklist, -- Middle widget
        {           -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            textclock,
        },
    }
end)
-- }}}

-- {{{ Key bindings
local globalkeys = gears.table.join(
    awful.key({ modkey, }, 'Escape', awful.tag.history.restore,
        { description = 'go back', group = 'tag' }),

    awful.key({ modkey, }, 'j',
        function()
            awful.client.focus.byidx(1)
        end,
        { description = 'focus next by index', group = 'client' }
    ),
    awful.key({ modkey, }, 'k',
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = 'focus previous by index', group = 'client' }
    ),
    awful.key({ modkey, }, 'w', function() mainmenu:show() end,
        { description = 'show main menu', group = 'awesome' }),

    -- Layout manipulation
    awful.key({ modkey, 'Shift' }, 'j', function() awful.client.swap.byidx(1) end,
        { description = 'swap with next client by index', group = 'client' }),
    awful.key({ modkey, 'Shift' }, 'k', function() awful.client.swap.byidx(-1) end,
        { description = 'swap with previous client by index', group = 'client' }),
    awful.key({ modkey, 'Control' }, 'j', function() awful.screen.focus_relative(1) end,
        { description = 'focus the next screen', group = 'screen' }),
    awful.key({ modkey, 'Control' }, 'k', function() awful.screen.focus_relative(-1) end,
        { description = 'focus the previous screen', group = 'screen' }),
    awful.key({ modkey, }, 'u', awful.client.urgent.jumpto,
        { description = 'jump to urgent client', group = 'client' }),
    awful.key({ modkey, }, 'Tab',
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = 'go back', group = 'client' }),

    -- Standard program
    awful.key({ modkey, }, 'Return', function() awful.spawn(terminal) end,
        { description = 'open a terminal', group = 'launcher' }),
    awful.key({ modkey, 'Shift' }, 'Return', function() awful.spawn({terminal, '-e', shell}) end,
        { description = 'open a terminal running shell', group = 'launcher' }),
    awful.key({ modkey, }, 'b', function() awful.spawn(browser) end,
        { description = 'open a terminal', group = 'launcher' }),
    awful.key({ modkey, 'Shift' }, 'e', awesome.quit,
        { description = 'quick awesome', group = 'awesome' }),
    awful.key({ modkey, 'Control' }, 'r', awesome.restart,
        { description = 'reload awesome', group = 'awesome' }),
    awful.key({ modkey, }, 'l', function() awful.screen.focus_bydirection('right') end,
        { description = 'increase master width factor', group = 'layout' }),
    awful.key({ modkey, }, 'h', function() awful.screen.focus_bydirection('left') end,
        { description = 'decrease master width factor', group = 'layout' }),
    awful.key({ modkey, 'Shift' }, 'l', function() awful.tag.incmwfact(0.05) end,
        { description = 'increase master width factor', group = 'layout' }),
    awful.key({ modkey, 'Shift' }, 'h', function() awful.tag.incmwfact(-0.05) end,
        { description = 'decrease master width factor', group = 'layout' }),
    awful.key({ modkey, }, 'space', function() awful.layout.inc(1) end,
        { description = 'select next', group = 'layout' }),
    awful.key({ modkey, 'Shift' }, 'space', function() awful.layout.inc(-1) end,
        { description = 'select previous', group = 'layout' }),

    awful.key({ modkey, 'Control' }, 'n',
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    'request::activate', 'key.unminimize', { raise = true }
                )
            end
        end,
        { description = 'restore minimized', group = 'client' }),

    -- Menubar
    awful.key({ modkey }, 'r', function() awful.spawn({'rofi', '-show', 'run'}) end,
        { description = 'run a program', group = 'awesome' }),
    awful.key({ modkey }, 'w', function() awful.spawn({'rofi', '-show', 'run'}) end,
        { description = 'run a program', group = 'awesome' })
)

local clientkeys = gears.table.join(
    awful.key({ modkey, }, 'g',
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = 'toggle fullscreen', group = 'client' }),
    awful.key({ modkey, 'Shift' }, 'q', function(c) c:kill() end,
        { description = 'close', group = 'client' }),
    awful.key({ modkey, 'Control' }, 'space', awful.client.floating.toggle,
        { description = 'toggle floating', group = 'client' }),
    awful.key({ modkey, 'Control' }, 'Return', function(c) c:swap(awful.client.getmaster()) end,
        { description = 'move to master', group = 'client' }),
    awful.key({ modkey, }, 'o', function(c) c:move_to_screen() end,
        { description = 'move to screen', group = 'client' }),
    awful.key({ modkey, }, 't', function(c) c.ontop = not c.ontop end,
        { description = 'toggle keep on top', group = 'client' }),
    awful.key({ modkey, }, 'n',
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = 'minimize', group = 'client' }),
    awful.key({ modkey, }, 'm',
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = '(un)maximize', group = 'client' }),
    awful.key({ modkey, 'Control' }, 'm',
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = '(un)maximize vertically', group = 'client' }),
    awful.key({ modkey, 'Shift' }, 'm',
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = '(un)maximize horizontally', group = 'client' })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i, k in ipairs({ 'a', 's', 'd', 'f', 'z', 'x', 'c', 'v' }) do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, k,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = 'view tag ' .. k, group = 'tag' }),
        -- Toggle tag display.
        awful.key({ modkey, 'Control' }, k,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = 'toggle tag ' .. k, group = 'tag' }),
        -- Move client to tag.
        awful.key({ modkey, 'Shift' }, k,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = 'move focused client to tag ' .. k, group = 'tag' }),
        -- Toggle tag on focused client.
        awful.key({ modkey, 'Control', 'Shift' }, k,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = 'toggle focused client on tag ' .. k, group = 'tag' })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = 0,
            border_color = 0,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                'DTA', -- Firefox addon DownThemAll.
                'copyq', -- Includes session name in class.
                'pinentry',
            },
            class = {
                'Arandr',
                'Blueman-manager',
                'Gpick',
                'Kruler',
                'MessageWin', -- kalarm.
                'mpv',
                'Sxiv',
                'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
                'Wpa_gui',
                'veromix',
                'xtightvncviewer' },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                'Event Tester', -- xev.
            },
            role = {
                'AlarmWindow', -- Thunderbird's calendar.
                'ConfigManager', -- Thunderbird's about:config.
                'pop-up',  -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },
}

client.connect_signal('manage', function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    c.ontop = c.floating
end)

client.connect_signal('mouse::enter', function(c)
    c:emit_signal('request::activate', 'mouse_enter', { raise = false })
end)

client.connect_signal('focus', function(c) c.border_color = beautiful.border_focus end)
client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)

awful.spawn('xset r rate 200 50')
awful.spawn('setxkbmap us -option caps:escape')
