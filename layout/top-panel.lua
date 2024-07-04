local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local icons = require("theme.icons")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
local task_list = require("widget.task-list")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
-- local apw = require('apw.widget')
-- local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")
-- local mpris_widget = require("awesome-wm-widgets.mpris-widget")
local tag_list = require("widget.tag-list")

-- Keyboard layout
local keyboard_layout = awful.widget.keyboardlayout:new()

local top_panel = function(s, offset)
	-- local action_bar_width = dpi(45)
	local offsetx = 0
	-- if offset == true then
	-- 	offsetx = dpi(45)
	-- end

	local panel = wibox({
		ontop = true,
		screen = s,
		type = "dock",
		height = dpi(45),
		width = s.geometry.width - offsetx,
		x = s.geometry.x + offsetx,
		y = s.geometry.y,
		stretch = false,
		bg = beautiful.background,
		fg = beautiful.fg_normal,
	})

	panel:struts({
		top = dpi(45),
	})

	panel:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "left_ptr"
		end
	end)

	s.systray = wibox.widget({
		visible = true,
		base_size = dpi(20),
		horizontal = true,
		screen = "primary",
		widget = wibox.widget.systray,
	})

	local clock = require("widget.clock")(s)
	local layout_box = require("widget.layoutbox")(s)
	local add_button = require("widget.open-default-app")(s)
	s.tray_toggler = require("widget.tray-toggle")
	-- s.updater = require("widget.package-updater")()
	-- s.screen_rec = require("widget.screen-recorder")()
	s.mpd = require("widget.mpd")()
	-- s.bluetooth   			= require('widget.bluetooth')()
	s.battery     			= require('widget.battery')()
	s.network = require("widget.network")()
	s.info_center_toggle = require("widget.info-center-toggle")()
	-- s.apw_container = wibox.container.background(apw)
	-- s.apw_container.forced_width = 40
	panel:setup({

		layout = wibox.layout.align.horizontal,
		expand = "none",
		{
			layout = wibox.layout.fixed.horizontal,
			tag_list(s),
			task_list(s),
			add_button,
		},
		nil,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(5),
			{
				s.systray,
				left = dpi(5),
				right = dpi(5),
				top = dpi(12),
				bottom = dpi(12),
				widget = wibox.container.margin,
			},
			-- s.bluetooth,
			s.tray_toggler,
			--s.updater,
			--s.screen_rec,
			-- s.mpd,
			--s.network,
			s.battery,
			clock,
			spacing = dpi(5),
			{
				-- s.systray,
				left = dpi(5),
				right = dpi(5),
				top = dpi(12),
				bottom = dpi(12),
				widget = wibox.container.margin,
			},
			keyboard_layout,
			-- volume_widget({ widget_type = "arc" }),
			-- s.apw_container,
			layout_box,
			s.info_center_toggle,
		},
	})

	return panel
end

return top_panel
