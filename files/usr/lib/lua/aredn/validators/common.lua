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
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

  Additional Terms:

  Additional use restrictions exist on the AREDN(TM) trademark and logo.
    See AREDNLicense.txt for more info.

  Attributions to the AREDN Project must be retained in the source code.
  If importing this code into a new or existing project attribution
  to the AREDN project must be added to the source code.

  You must not misrepresent the origin of the material contained within.

  Modified versions must be modified to attribute to the original source
  and be marked in reasonable ways as differentiate it from the original
  version.

--]]

--------------------- COMMON validators ------------------

local json = require("luci.jsonc")
local dbg = require("debug")
require("aredn.utils")

-------------------------------------
-- Public API is attached to table
-------------------------------------
local model = {}


-------------------------------------
--    IP Address data
-------------------------------------
function model.ipAddress(value, field_name)
  field_name = field_name or dbg.getinfo(1).name
  local result = {}
  local msgs = {}
  
  if get_ip_type(value)~=1 then
    table.insert(msgs, "Not a valid IPv4 address")
  end
  
  if #msgs > 0 then 
    result['field'] = field_name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    NETMASK data
-------------------------------------
function model.netmask(value, field_name)
  field_name = field_name or dbg.getinfo(1).name
  local result = {}
  local msgs = {}
  
  if get_ip_type(value)~=1 then
    table.insert(msgs, "Not a valid netmask")
  end
  
  if #msgs > 0 then 
    result['field'] = field_name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    Generic Boolean data
-------------------------------------
function model.boolean(value, field_name)
  field_name = field_name or dbg.getinfo(1).name
  local result = {}
  local msgs = {}
  
  if type(value)~="boolean" then
    table.insert(msgs, "Not a valid boolean value")
  end
  
  if #msgs > 0 then 
    result['field'] = field_name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

return model