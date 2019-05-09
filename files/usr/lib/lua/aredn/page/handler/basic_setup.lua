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
local valid = require("aredn.validators.basic_setup")
local common_valid = require("aredn.validators.common")
local common_ph = require("aredn.page.handler.common")
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
	local pres

	-- NODE_INFO
	common_ph.validateField(errors, valid.nodeName, data.node_info.name)
	common_ph.validateField(errors, valid.nodePassword, data.node_info.password)
	common_ph.validateField(errors, valid.nodeDescription, data.node_info.description)
	
	-- MESH_RF
	common_ph.validateField(errors, common_valid.ipAddress, data.mesh_rf.ip)
	common_ph.validateField(errors, common_valid.netmask, data.mesh_rf.netmask)
	common_ph.validateField(errors, valid.ssidPrefix, data.mesh_rf.ssid_prefix)
	common_ph.validateField(errors, valid.channel, data.mesh_rf.channel)
	common_ph.validateField(errors, valid.bandwidth, data.mesh_rf.bandwidth)
	--	common_ph.validateField(errors, valid.power, data.mesh_rf.power)
	common_ph.validateField(errors, valid.distance, data.mesh_rf.distance)
	
	-- LAN
	common_ph.validateField(errors, valid.lanMode, data.lan.mode)
	
	-- WAN
	common_ph.validateField(errors, valid.wanProtocol, data.wan.protocol)
	common_ph.validateField(errors, common_valid.ipAddress, data.wan.dns.primary, "dns_primary")
	common_ph.validateField(errors, common_valid.ipAddress, data.wan.dns.secondary, "dns_secondary")

	-- ADVANCED WAN
	-- mesh_gateway (boolean)
	-- default_route (boolean)

	-- LOCATION
	common_ph.validateField(errors, valid.latitude, data.location.latitude)
	common_ph.validateField(errors, valid.longitude, data.location.longitude)
	common_ph.validateField(errors, valid.gridSquare, data.location.gridsquare)
	
	-- TIME
	common_ph.validateField(errors, valid.timezone, data.time.timezone)
	
	if #errors > 0 then 
		return errors
	else
		-- memory cleanup (unload validators)
		valid = nil
		common_valid = nil

		--------- persist settings
		local store = require("aredn.persistors.basic_setup")
		local u=uci:cursor()

		-- NODE_INFO

		common_ph.storeValue(errors, store.nodeName, u, data.node_info.name)
		common_ph.storeValue(errors, store.nodePassword, u, data.node_info.password)
		-- common_ph.storeValue(errors, store.nodeDescription, data.node_info.description)
--[[
		-- MESH_RF
		common_ph.storeValue(errors, store.meshRfIpAddress, u, data.mesh_rf.ip)
		common_ph.storeValue(errors, store.meshRfNetmask, u, data.mesh_rf.netmask)
		common_ph.storeValue(errors, store.ssidPrefix, u, data.mesh_rf.ssid_prefix)
		common_ph.storeValue(errors, store.channel, u, data.mesh_rf.channel)
		common_ph.storeValue(errors, store.bandwidth, u, data.mesh_rf.bandwidth)
	--	common_ph.storeValue(errors, store.power, u, data.mesh_rf.power)
		common_ph.storeValue(errors, store.distance, u, data.mesh_rf.distance)
		
		-- LAN
		common_ph.storeValue(errors, store.lanMode, u, data.lan.mode)
		
		-- WAN
		common_ph.storeValue(errors, store.wanProtocol, u, data.wan.protocol)
		common_ph.storeValue(errors, store.wanDNSPrimary.ipAddress, u, data.wan.dns.primary, "dns_primary")
		common_ph.storeValue(errors, store.wanDNSSecondary.ipAddress, u, data.wan.dns.secondary, "dns_secondary")

		-- ADVANCED WAN
		-- mesh_gateway (boolean)
		-- default_route (boolean)
]]
		-- LOCATION
		common_ph.storeValue(errors, store.latitude, u, data.location.latitude)
--[[
		common_ph.storeValue(errors, store.longitude, u, data.location.longitude)
		common_ph.storeValue(errors, store.gridSquare, u, data.location.gridsquare)
		
		-- TIME
		common_ph.storeValue(errors, store.timezone, u, data.time.timezone)

		common_ph.storeValue(errors, store.ntpServer, u, data.time.ntp)
]]		
		if #errors > 0 then
			return errors
		else
			if u:commit("system") and u:commit("aredn") then
				return "success"
			else
				return "failed"
			end
		end
	end
end

return model