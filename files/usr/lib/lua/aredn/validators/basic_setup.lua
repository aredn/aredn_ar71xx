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

--------------------- BASIC SETUP validators ------------------

local json = require("luci.jsonc")
local dbg = require("debug")
require("aredn.utils")

-------------------------------------
-- Public API is attached to table
-------------------------------------
local model = {}

-- ++++++++++++++++++++++++++++++++++
-- BASIC SETUP data
-- ++++++++++++++++++++++++++++++++++
-- ==================================
--  NODE_INFO section data
-- ==================================
-------------------------------------
--    Node name
-------------------------------------
function model.nodeName(value)
  local result = {}
  local msgs = {}
  
  if value==nil or value=="" then
    table.insert(msgs, "Node name cannot be empty")
  else
    if value:containsSpaces() then
      table.insert(msgs, "Node name cannot contain spaces")
    end
    
    if value:startsWith("_") then
      table.insert(msgs, "Node name cannot start with an underscore")
    end
  end

  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    Node Password
-------------------------------------
function model.nodePassword(value)
  local result = {}
  local msgs = {}
  
  if value==nil or value=="" then
    table.insert(msgs, "Node password cannot be empty")
  else
    if value:contains("#") then
      table.insert(msgs, "Node password cannot contain # characters")
    end
    if value=="hsmm" then   -- check for default password
      table.insert(msgs, "Node password cannot be set to the default password.")
    end
  end

  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    Node Description
-------------------------------------
function model.nodeDescription(value)
  return true
end

-- ==================================
--  MESH_RF section data
-- ==================================
-------------------------------------
--    RF Enabled (COMMON)
-------------------------------------
-------------------------------------
--    IP Address data (COMMON)
-------------------------------------
-------------------------------------
--    NETMASK data (COMMON)
-------------------------------------
-------------------------------------
--    SSID data
-------------------------------------
function model.ssidPrefix(value)
  local result = {}
  local msgs = {}
  
  if #value > 32 then
    table.insert(msgs, "SSID prefix must be 32 characters or less")
  end
  
  if value:contains("'") then
    table.insert(msgs, "SSID prefix cannot contains single quotes")
  end

  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    CHANNEL data
-------------------------------------
function model.channel(value)
  local channels = require("aredn.channels")
  local result = {}
  local msgs = {}
  -- local band = aredn_info.getBand()
  local band = "2400"            --------------------------------------------- DEBUGGING ONLY
  local clist = channels.getChannels(band)
  local found = false

  for c,f in pairs(clist) do    -- cannot use ipairs because clist may contain negative index values on 2ghz
    if c==tonumber(value) then
      found=true
      break
    end
  end

  if not found then
    table.insert(msgs, "Invalid channel number")
  end

  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    BANDWIDTH data
-------------------------------------
function model.bandwidth(value)
  local result = {}
  local msgs = {}
  local bwlist = {5,10,20}

  local intval = tonumber(value)
  if type(intval)~="number" then
    table.insert(msgs, "Bandwidth value must be numeric")
  else
    if not listContains(bwlist, intval) then
      table.insert(msgs, "Bandwidth value must be either: 5, 10, or 20")
    end
  end
  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    POWER data
-------------------------------------

-------------------------------------
--    DISTANCE data
-------------------------------------
function model.distance(value)
  local result = {}
  local msgs = {}
  
  local intval = tonumber(value)
  if type(intval)~="number" then
    table.insert(msgs, "Distance value must be numeric")
  else
    if not (intval>=0 and intval <=150) then
      table.insert(msgs, "Distance value must be between 0 and 150")
    end
  end
  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end


-- ==================================
--  LAN section data
-- ==================================
-------------------------------------
--    LAN MODE data
-------------------------------------
function model.lanMode(value)
  local result = {}
  local msgs = {}
  local bwlist = {0,2,3,4,5}  -- NAT, 1 host, 5 hosts, 13 hosts, 29 hosts

  local intval = tonumber(value)
  if type(intval)~="number" then
    table.insert(msgs, "LAN mode value must be numeric")
  else
    if not listContains(bwlist, intval) then
      table.insert(msgs, "LAN mode value must be either: 0 (NAT), 2 (1 host direct), 3 (5 host direct), 4 (13 host direct), or 5 (29 host direct)")
    end
  end
  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-- ==================================
--  WAN section data
-- ==================================
-------------------------------------
--    WAN protocol (DHCP mode) data
-------------------------------------
function model.wanProtocol(value)
  local result = {}
  local msgs = {}
  local mlist = {"static", "dhcp", "disabled"}

  if value==nil or value=="" then
    table.insert(msgs, "WAN protocol cannot be empty")
  else
    if not listContains(mlist, value) then
        table.insert(msgs, "WAN protocol value must be either: static, dhcp, or disabled (" .. value .. ")")
    end
  end
  
  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    WAN DNS PRIMARY/SECONDARY data
--    (uses common.ipAddress validator)
-------------------------------------

-- ==================================
--  ADVANCED WAN section data
-- ==================================

-- ==================================
--  LOCATION section data
-- ==================================
-------------------------------------
--    LATITUDE data
-------------------------------------
function model.latitude(value)
  local result = {}
  local msgs = {}

  local intval = tonumber(value)
  if type(intval)~="number" then
    table.insert(msgs, "Latitude value must be numeric")
  else
    if not (intval >=-90 and intval <=90) then
      table.insert(msgs, "Latitude value must be between -90 and 90")
    end
  end

  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    LONGITUDE data
-------------------------------------
function model.longitude(value)
  local result = {}
  local msgs = {}

  local intval = tonumber(value)
  if type(intval)~="number" then
    table.insert(msgs, "Longitude value must be numeric")
  else
    if not (intval >=-180 and intval <=180) then
      table.insert(msgs, "Longitude value must be between -180 and 180")
    end
  end
  
  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    GRIDSQUARE data
-------------------------------------
function model.gridSquare(value)
  return true
end

-- ==================================
--  TIME section data
-- ==================================
-------------------------------------
--    Timezone
-------------------------------------
function model.timezone(value)
  local result = {}
  local msgs = {}

  local aredn_info=require("aredn.info")
  local hasTZ = listContains(aredn_info.getListOfTimezones(), value)  
  if hasTZ==nil then
    table.insert(msgs, "Timezone is invalid")
  end

  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
--    NTP Server data
-------------------------------------
function model.ntpServer(value)
  return true
end

return model