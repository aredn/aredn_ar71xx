#!/bin/sh
true <<'LICENSE'
  Part of AREDN -- Used for creating Amateur Radio Emergency Data Networks
  Copyright (C) 2020 Darryl Quinn K5DLQ
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

LICENSE

# does the node have access to downloads.arednmesh.org
ping -q -W10 -c1 downloads.arednmesh.org > /dev/null && 
  online=true;
  [ -f /tmp/aredn_message ] && 
  rm /tmp/aredn_message


if [ $online = "true" ] 
then
  # fetch node specific message file
  # nodename=$(echo "$HOSTNAME" | tr 'A-Z' 'a-z')
  nodename=$(echo "$HOSTNAME" | tr 'A-Z' 'a-z')
  wget -q -O aredn_message -P /tmp http://downloads.arednmesh.org/messages/"${nodename}".txt
  if [ $? -ne 0 ] # no node specific file
  then
    # fetch broadcast message file
    wget -q -O aredn_message -P /tmp http://downloads.arednmesh.org/messages/all.txt
  else
    # need to append to node file
    wget -q -O aredn_message_all -P /tmp http://downloads.arednmesh.org/messages/all.txt &&
      echo "<br />" >> /tmp/aredn_message;
      cat /tmp/aredn_message_all >> /tmp/aredn_message;
      rm /tmp/aredn_message_all;
  fi
fi

