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
require("aredn.utils")
-------------------------------------
-- Public API is attached to table
-------------------------------------
local model = {}

-------------------------------------
-- Sample validator
-------------------------------------
function model.foo(value)
  local result = {}
  result['rc'] = false
  result['msg'] = "this did not validate due to foobar"
  return result
end


-------------------------------------
-- Node name
-------------------------------------
function model.nodeName(value)
  local result = {}
  result['rc'] = false

  if value==nil or value=="" then
    result['msg'] = "Node name cannot be empty"
    return result
  end

  if value:containsSpaces() then
    result['msg'] = "Node name cannot contain spaces"
    return result
  end
  
  if value:startsWith("_") then
    result['msg'] = "Node name cannot start with an underscore"
    return result
  end

  -- passed all the tests
  result['rc'] = true
  return result
end

-------------------------------------
-- Node Password
-------------------------------------
function model.nodePassword(value)
  local result = {}
  result['rc'] = false

  if value==nil or value=="" then
    result['msg'] = "Node password cannot be empty"
    return result
  end

  -- check for #
  if value:contains("#") then
    result['msg'] = "Node password cannot contain # characters"
    return result
  end

   -- check for default password
  if value=="hsmm" then
    result['msg'] = "Node password cannot be set to the default password."
    return result
  end

  -- passed all the tests
  result['rc'] = true
  return result
end

-------------------------------------
-- Node Description
-------------------------------------
function model.nodeDescription(value)
  local result = {}
  result['rc'] = true
  return result
end



return model