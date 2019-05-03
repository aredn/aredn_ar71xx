#!/usr/bin/lua
--[[

	Part of AREDN -- Used for creating Amateur Radio Emergency Data Networks
	Copyright (C) 2019 Darryl Quinn
	See Contributors file for additional contributors

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation version 3 of the License.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.	If not, see <http://www.gnu.org/licenses/>.

	Additional Terms:

	Additional use restrictions exist on the AREDN(TM) trademark and logo.
		See AREDNLicense.txt for more info.

	Attributions to the AREDN Project must be retained in the source code.
	If importing this code into a new or existing project attribution
	to the AREDN project must be added to the source code.

	You must not misrepresent the origin of the material contained within.

	Modified versions must be modified to attribute to the original source
	and be marked in reasonable ways as differentiate it from the original
	version

--]]

require("uci")
require("aredn.uci")
require("aredn.utils")
require("nixio")
local valid = require("aredn.validators")
local json = require("luci.jsonc")

-- Function extensions
os.capture = capture

model = {}

-------------------------------------
-- BASIC SETUP page handler
-------------------------------------
function model.page_handler(data)
	local result = {}
	local errors = {}
	local vres

	-- NODE_INFO
	vres=valid.nodeName(data.node_info.name)
	if vres~=true then
		table.insert(errors, vres)
	end

	vres=valid.nodePassword(data.node_info.password)
	if vres~=true then
		table.insert(errors, vres)
	end

	vres=valid.nodeDescription(data.node_info.description)
	if vres~=true then
		table.insert(errors, vres)
	end

	-- MESH_RF
	vres=valid.ipAddress(data.mesh_rf.ip)
	if vres~=true then
		table.insert(errors, vres)
	end

	vres=valid.netmask(data.mesh_rf.netmask)
	if vres~=true then
		table.insert(errors, vres)
	end

	vres=valid.ssidPrefix(data.mesh_rf.ssid_prefix)
	if vres~=true then
		table.insert(errors, vres)
	end
--[[
	vres=valid.channel(data.mesh_rf.channel)
	if vres~=true then
		table.insert(errors, vres)
	end
--]]
	vres=valid.bandwidth(data.mesh_rf.bandwidth)
	if vres~=true then
		table.insert(errors, vres)
	end
--[[
	vres=valid.power(data.mesh_rf.power)
	if vres~=true then
		table.insert(errors, vres)
	end
--]]
	vres=valid.distance(data.mesh_rf.distance)
	if vres~=true then
		table.insert(errors, vres)
	end

	-- LAN
	vres=valid.lanMode(data.lan.mode)
	if vres~=true then
		table.insert(errors, vres)
	end

	-- WAN
	vres=valid.wanProtocol(data.wan.protocol)
	if vres~=true then
		table.insert(errors, vres)
	end

--[[
	vres=valid.ipAddress(data.wan.dns.primary)
	if vres~=true then
		table.insert(errors, vres)
	end

	vres=valid.wanMode(data.wan.dns.secondary)
	if vres~=true then
		table.insert(errors, vres)
	end
]]
	-- ADVANCED WAN

	-- LOCATION
	vres=valid.latitude(data.location.latitude)
	if vres~=true then
		table.insert(errors, vres)
	end
	
	vres=valid.longitude(data.location.longitude)
	if vres~=true then
		table.insert(errors, vres)
	end

	vres=valid.gridSquare(data.location.gridsquare)
	if vres~=true then
		table.insert(errors, vres)
	end

	-- TIME
	vres=valid.timezone(data.time.timezone)
	if vres~=true then
		table.insert(errors, vres)
	end

	--------- persist settings
	--------- persist settings


	if #errors > 0 then 
		return errors
	else
		return "success"
	end
end

return model