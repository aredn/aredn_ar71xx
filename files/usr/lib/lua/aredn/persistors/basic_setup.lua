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

--------------------- BASIC SETUP persistors ------------------

local uci = require("uci")
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
function model.nodeName(u, value)
  return u:set("system", "@system[0]", "hostnametest", value)
end

-------------------------------------
--    Node Password
-------------------------------------
function model.nodePassword(u, value)
  return false
end

-------------------------------------
--    Node Description
-------------------------------------
function model.nodeDescription(u, value)
  return u:set("system", "@system[0]", "description", value)
end

-- ==================================
--  MESH_RF section data
-- ==================================
-------------------------------------
--    IP Address data (COMMON)
-------------------------------------
-------------------------------------
--    NETMASK data (COMMON)
-------------------------------------
-------------------------------------
--    SSID data
-------------------------------------
function model.ssidPrefix(u, value)
  return false
end

-------------------------------------
--    CHANNEL data
-------------------------------------
function model.channel(u, value)
  return false
end

-------------------------------------
--    BANDWIDTH data
-------------------------------------
function model.bandwidth(u, value)
  return false
end

-------------------------------------
--    POWER data
-------------------------------------

-------------------------------------
--    DISTANCE data
-------------------------------------
function model.distance(u, value)
  return false
end


-- ==================================
--  LAN section data
-- ==================================
-------------------------------------
--    LAN MODE data
-------------------------------------
function model.lanMode(u, value)
  return false
end

-- ==================================
--  WAN section data
-- ==================================
-------------------------------------
--    WAN protocol (DHCP mode) data
-------------------------------------
function model.wanProtocol(u, value)
  return false
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
function model.latitude(u, value)
  return false
end

-------------------------------------
--    LONGITUDE data
-------------------------------------
function model.longitude(u, value)
  return false
end

-------------------------------------
--    GRIDSQUARE data
-------------------------------------
function model.gridSquare(u, value)
  return false
end

-- ==================================
--  TIME section data
-- ==================================
-------------------------------------
--    Timezone
-------------------------------------
function model.timezone(u, value)
  return u:set("system", "@system[0]", "timezone", value)
end

-------------------------------------
--    NTP Server data
-------------------------------------
function model.ntpServer(u, value)
  local current = {}
  -- we only allow one ntp server, get get the existing one
  current=u:get("system","ntp","server")
  -- then update it
  current[1]=value
  if u:set("system","ntp", "server", current) then
    return true
  end
  return false
end

return model