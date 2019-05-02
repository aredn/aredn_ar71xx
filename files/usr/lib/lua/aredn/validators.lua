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

local json = require("luci.jsonc")
local dbg = require("debug")
require("aredn.utils")

-------------------------------------
-- Public API is attached to table
-------------------------------------
local model = {}

-------------------------------------
-- Node name
-------------------------------------
function model.nodeName(value)
  local result = {}
  local msgs = {}
  
  if value==nil or value=="" then
    table.insert(msgs, "Node name cannot be empty")
  end

  if value:containsSpaces() then
    table.insert(msgs, "Node name cannot contain spaces")
  end
  
  if value:startsWith("_") then
    table.insert(msgs, "Node name cannot start with an underscore")
  end

  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
-- Node Password
-------------------------------------
function model.nodePassword(value)
  local result = {}
  local msgs = {}
  
  if value==nil or value=="" then
    table.insert(msgs, "Node password cannot be empty")
  end

  -- check for #
  if value:contains("#") then
    table.insert(msgs, "Node password cannot contain # characters")
  end

   -- check for default password
  if value=="hsmm" then
    table.insert(msgs, "Node password cannot be set to the default password.")
  end

  if #msgs > 0 then 
    result['field'] = dbg.getinfo(1).name     -- use reflection to get this function's name
    result['messages'] = msgs
    return result
  end
  return true
end

-------------------------------------
-- Node Description
-------------------------------------
function model.nodeDescription(value)
  return true
end

-------------------------------------
-- Timezone
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


return model