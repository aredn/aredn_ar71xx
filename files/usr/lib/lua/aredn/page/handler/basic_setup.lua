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

	-- validate fields
	vres=valid.nodeName(data.node_info.name)
	if vres~=true then
		table.insert(errors, vres)
	end

	vres=valid.nodePassword(data.node_info.password)
	if vres~=true then
		table.insert(errors, vres)
	end

	vres=valid.timezone(data.time.timezone)
	if vres~=true then
		table.insert(errors, vres)
	end

	-- persist settings

	if #errors > 0 then 
		return errors
	else
		return "ok"
	end
end

return model