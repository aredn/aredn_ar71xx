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
  version

--]]

require("aredn.utils")

-- Function extensions
os.capture = capture

-------------------------------------
-- Public API is attached to table
-------------------------------------
local model = {}

-------------------------------------
-- return CHANNELS by band
-------------------------------------
function model.getChannels(band)
  local c = {}
  -- 900 Mhz
  c['900'] = {}
  c['900']['4'] = "907"
  c['900']['5'] = "912"
  c['900']['6'] = "917"
  c['900']['7'] = "922"

  -- 2400 Mhz (2.4 Ghz)
  c['2400'] = {}
  c['2400'][-2] = 2397
  c['2400'][-1] = 2402
  c['2400'][1]  = 2412
  c['2400'][2]  = 2417
  c['2400'][3]  = 2422
  c['2400'][4]  = 2427
  c['2400'][5]  = 2432
  c['2400'][6]  = 2437
  c['2400'][7]  = 2442
  c['2400'][8]  = 2447
  c['2400'][9]  = 2452
  c['2400'][10] = 2457
  c['2400'][11] = 2462

  -- 3400 Mhz (3 Ghz)
  c['3400'] = {}
  c['3400']['76'] = "3380"
  c['3400']['77'] = "3385"
  c['3400']['78'] = "3390"
  c['3400']['79'] = "3395"
  c['3400']['80'] = "3400"
  c['3400']['81'] = "3405"
  c['3400']['82'] = "3410"
  c['3400']['83'] = "3415"
  c['3400']['84'] = "3420"
  c['3400']['85'] = "3425"
  c['3400']['86'] = "3430"
  c['3400']['87'] = "3435"
  c['3400']['88'] = "3440"
  c['3400']['89'] = "3445"
  c['3400']['90'] = "3450"
  c['3400']['91'] = "3455"
  c['3400']['92'] = "3460"
  c['3400']['93'] = "3465"
  c['3400']['94'] = "3470"
  c['3400']['95'] = "3475"
  c['3400']['96'] = "3480"
  c['3400']['97'] = "3485"
  c['3400']['98'] = "3490"
  c['3400']['99'] = "3495"

  c['5500'] = {}
  c['5500']['37'] = "5190"
  c['5500']['40'] = "5200"
  c['5500']['44'] = "5220"
  c['5500']['48'] = "5240"
  c['5500']['52'] = "5260"
  c['5500']['56'] = "5280"
  c['5500']['60'] = "5300"
  c['5500']['64'] = "5320"
  c['5500']['100'] = "5500"
  c['5500']['104'] = "5520"
  c['5500']['108'] = "5540"
  c['5500']['112'] = "5560"
  c['5500']['116'] = "5580"
  c['5500']['120'] = "5600"
  c['5500']['124'] = "5620"
  c['5500']['128'] = "5640"
  c['5500']['132'] = "5660"
  c['5500']['136'] = "5680"
  c['5500']['140'] = "5700"
  c['5500']['149'] = "5745"
  c['5500']['153'] = "5765"
  c['5500']['157'] = "5785"
  c['5500']['161'] = "5805"
  c['5500']['165'] = "5825"

  c['5800'] = {}
  c['5800']['133'] = "5665"
  c['5800']['134'] = "5670"
  c['5800']['135'] = "5675"
  c['5800']['136'] = "5680"
  c['5800']['137'] = "5685"
  c['5800']['138'] = "5690"
  c['5800']['139'] = "5695"
  c['5800']['140'] = "5700"
  c['5800']['141'] = "5705"
  c['5800']['142'] = "5710"
  c['5800']['143'] = "5715"
  c['5800']['144'] = "5720"
  c['5800']['145'] = "5725"
  c['5800']['146'] = "5730"
  c['5800']['147'] = "5735"
  c['5800']['148'] = "5740"
  c['5800']['149'] = "5745"
  c['5800']['150'] = "5750"
  c['5800']['151'] = "5755"
  c['5800']['152'] = "5760"
  c['5800']['153'] = "5765"
  c['5800']['154'] = "5770"
  c['5800']['155'] = "5775"
  c['5800']['156'] = "5780"
  c['5800']['157'] = "5785"
  c['5800']['158'] = "5790"
  c['5800']['159'] = "5795"
  c['5800']['160'] = "5800"
  c['5800']['161'] = "5805"
  c['5800']['162'] = "5810"
  c['5800']['163'] = "5815"
  c['5800']['164'] = "5820"
  c['5800']['165'] = "5825"
  c['5800']['166'] = "5830"
  c['5800']['167'] = "5835"
  c['5800']['168'] = "5840"
  c['5800']['169'] = "5845"
  c['5800']['170'] = "5850"
  c['5800']['171'] = "5855"
  c['5800']['172'] = "5860"
  c['5800']['173'] = "5865"
  c['5800']['174'] = "5870"
  c['5800']['175'] = "5875"
  c['5800']['176'] = "5880"
  c['5800']['177'] = "5885"
  c['5800']['178'] = "5890"
  c['5800']['179'] = "5895"
  c['5800']['180'] = "5900"
  c['5800']['181'] = "5905"
  c['5800']['182'] = "5910"
  c['5800']['183'] = "5915"
  c['5800']['184'] = "5920"

  if setContains(c, band) then
    return c[band]
  else
    return nil
  end
end

return model

--[[

 
sub is_channel_valid
{
    my ($channel) = @_;

    if ( !defined($channel) ) {
        return -1;
    }

    $boardinfo=hardware_info();
    #We know about the band so lets use it
    if ( exists($boardinfo->{'rfband'}))
    {
        $validchannels=rf_channel_map($boardinfo->{'rfband'});

        if ( exists($validchannels->{$channel}) )
        {
            return 1;
        } else {
            return 0;
        }
    }
    # We don't have the device band in the data file so lets fall back to checking manually
    else {
        my $channelok=0;
        my $wifiintf = get_interface("wifi");
        foreach (`iwinfo $wifiintf freqlist`)
        {
            next unless /Channel $channel/;
            next if /\[restricted\]/;
            $channelok=1;
        }
        return $channelok;
    }

}


sub rf_channels_list
{

    $boardinfo=hardware_info();
    #We know about the band so lets use it
    if ( exists($boardinfo->{'rfband'}))
    {
        if (rf_channel_map($boardinfo->{'rfband'}) != -1 )
        {
            return rf_channel_map($boardinfo->{'rfband'});
        }
    }
    else
    {          
        my  %channels = ();
        my $wifiintf = get_interface("wifi");
        foreach (`iwinfo $wifiintf freqlist` )
        {
            next unless /([0-9]+.[0-9]+) GHz \(Channel ([0-9]+)\)/;
            next if /\[restricted\]/;
            my $channelnum = $2;                                                
            my $channelfreq = $1;                                               
            $channelnum =~s/^0+//g;                                             
            $channels->{$channelnum}  = "$channelfreq GHZ" ;
        }
        return $channels;
    }
}

sub is_wifi_chanbw_valid
{
    # chan_bw valid
    return 1;
}


sub rf_default_channel
{

    my %default_rf = (
        '900' => {
            chanbw  => "5",
            channel => "5",
        },
        '2400' => {
            chanbw  => "10",
            channel => "-2",
        },
        '3400' => {
            chanbw  => "10",
            channel => "84",
        },
        '5800ubntus' => {
            chanbw  => "10",
            channel => "149",
        },
    );

    $boardinfo=hardware_info();
    #We know about the band so lets use it
    if ( exists($boardinfo->{'rfband'}))
    {
        return $default_rf{$boardinfo->{'rfband'}};
    }
    else {
        # Somewhat "expensive" in that it duplicates calls made above, but rare to be used. 
        my $channels = rf_channels_list(); 
        foreach $channelnumber (sort {$a <=> $b} keys %{$channels}) {
            return { chanbw => "5", channel => $channelnumber };
        }
    }
} 


]]