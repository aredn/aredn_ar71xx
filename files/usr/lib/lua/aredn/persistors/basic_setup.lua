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
require("uci")
-- local au = require("aredn.uci")
local json = require("luci.jsonc")
local dbg = require("debug")
require("aredn.utils")
local aredn_info = require("aredn.info")

-------------------------------------
-- Public API is attached to table
-------------------------------------
local model = {}

-------------------------------------
-- Private variables
-------------------------------------
local meshRadio = aredn_info.getMeshRadioDevice()


-------------------------------------
-- Private functions
-------------------------------------
function upsert(u, conf, sect, opt, value)
  if u:get(conf, sect)==nil then
    newsect = sect:gsub("^@", "")
    newsect = newsect:gsub("%[[0-9+]%]$","")
    u:add(conf, newsect)
  end
  return u:set(conf, sect, opt, value)
end

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
  --if u:get("system", "@system[0]")==nil then
  --  u:add("system", "@system")
  --end
  return upsert(u, "system", "@system[0]", "hostnametest", value)
end

-------------------------------------
--    Node Password
-------------------------------------
function model.nodePassword(u, value)
  local cmd=string.format("/usr/local/bin/setpasswd '%s'", value)
  local res=os.execute(cmd)
  if res==0 then
    return true
  else
    return false
  end
end

-------------------------------------
--    Node Description
-------------------------------------
function model.nodeDescription(u, value)
  if value==nil then value="" end
  return upsert(u, "system", "@system[0]", "description", value)
end

-- ==================================
--  MESH_RF section data
-- ==================================
-------------------------------------
--    MeshRF Enabled data
-------------------------------------
function model.meshRfEnabled(u, value)
  local ucival
  if value then
    ucival="0"  -- value is enabled, so the uci "disabled" value false "0"
  else
    ucival="1"
  end
  return upsert(u, "wireless", meshRadio, "disabled", ucival)
end

-------------------------------------
--    IP Address data
-------------------------------------
function model.meshRfIpAddress(u, value)
  return upsert(u, "aredn", "@meshrf[0]", "ipaddress", value)
end

-------------------------------------
--    NETMASK data
-------------------------------------
function model.meshRfNetmask(u, value)
  return upsert(u, "aredn", "@meshrf[0]", "netmask", value)
end

-------------------------------------
--    CHANNEL data
-------------------------------------
function model.channel(u, value)
  return upsert(u, "wireless", meshRadio, "channel", value)
end

-------------------------------------
--    BANDWIDTH data
-------------------------------------
function model.bandwidth(u, value)
  return upsert(u, "wireless", meshRadio, "chanbw", value)
end

-------------------------------------
--    SSID data (combination)
-------------------------------------
function model.ssid(u, ssid_prefix, bw)
  local protocol_ver = "v3"
  local ssid = ssid_prefix .. "-" .. bw .. "-" .. protocol_ver
  return upsert(u, "wireless", "@wifi-iface[0]", "ssid", ssid)
end

-------------------------------------
--    POWER data
-------------------------------------
function model.meshTxPower(u, value)
  return upsert(u, "aredn", "@meshrf[0]", "txpower", value)
end

-------------------------------------
--    DISTANCE data
-------------------------------------
function model.distance(u, value)
  local ms_distance
  value = tonumber(value)
  if value ~= 0 then
    ms_distance = round2(value * 151.5151 + 64, 0)
  else
    ms_distance = value
  end
  return upsert(u, "wireless", meshRadio, "distance", ms_distance)
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
  return upsert(u, "aredn", "@location[0]", "latitude", value)
end

-------------------------------------
--    LONGITUDE data
-------------------------------------
function model.longitude(u, value)
  return upsert(u, "aredn", "@location[0]", "longitude", value)
end

-------------------------------------
--    GRIDSQUARE data
-------------------------------------
function model.gridSquare(u, value)
  return upsert(u, "aredn", "@location[0]", "gridsquare", value)
end

-- ==================================
--  TIME section data
-- ==================================
-------------------------------------
--    Timezone
-------------------------------------
function model.timezone(u, value)
  return upsert(u, "system", "@system[0]", "timezone", value)
end

-------------------------------------
--    NTP Server data
-------------------------------------
function model.ntpServer(u, value)
  local current = {}
  -- we only allow one ntp server, get get the existing one
  current=u:get("system","ntp","server")
  current[1]=value
  if upsert(u, "system","ntp", "server", current) then
    return true
  end
  return false
end

return model