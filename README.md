# Amateur Radio Emergency Data Network AREDN(tm) Firmware

http://www.arednmesh.org

## Usage Information

### What to know about the images built with the instructions below

This is the 3.18.9.0 release build. (Protocol 3 compatible, Sept 2018, major release.)

Major enhancements from prior 3.16.2.0 release:

* olsrd upgrade from 0.6.7 to 0.9.6.2
* OpenWrt upgrade from 14.07 (July 2014) to 18.06.1 (Aug 2018)
* added Mikrotik basebox 2 and 5
* added Mikrotik hAP lite 952Ui-5ac2nD
* added tp-link cp210 v1.1, v2.0, v3.0, and cpe510 v2.0
* added numerous Ubiquiti "XW" devices
* compatible with all prior AREDN and BBHN 3.1.0 networks (called version 3)
* major linux kernel upgrade from 3.10.49 (July 2014) to 4.9.120 (Aug 2018)

Known issues in this release:

* Best practice: before firmware upgrade reboot to ensure sufficient RAM is available
* 32MB RAM devices have limited free RAM, installation of additional packages not recommended
* 32MB RAM devices with active tunnels may sustain high load with slow response
* Mikrotik hAP lite model is not yet functional on 5Ghz, is only configured for mesh RF on 2GHz
* Uniquiti PowerBeam devices with 1GB ports may frequently drop links over
    longer cat5 lengths. See work around at https://github.com/aredn/aredn_ar71xx/issues/165 

The following devices have a peculiar cat5 configuration due to a limitation in the Ethernet driver.
The 'Main" port is used for LAN devices only.  The "Secondary" port is WAN and DtDLink usage
only. Depending on deployed usage, 2 cat5 cables may be needed.

* Ubiquiti Nanostation M5 XW
* Ubiquiti Nanostation M2 XW
* TP-Link CPE210 v1.0 and v1.1
* TP-Link CPE510 v1.0 and v1.1

Latest Mikrotik installation options are found at:
https://www.arednmesh.org/content/installation-instructions-mikrotik-devices

### Images built

Device | Image to Use | RAM | Stability
------ | ------------ | --- | ---------
AirGrid XM | bullet-m | 32Mb | stable
AirGrid XW | loco-m-xw | 32Mb | stable
AirRouter  | airrouter | 32Mb | stable
AirRouter HP | airrouter | 32Mb | stable
Bullet M2/M2Ti/M5/M5Ti | bullet-m | 32Mb | stable
Bullet Ti | bullet-m | 32Mb | stable
NBE-M2-13/16/19 | loco-m-xw | 32Mb | stable
NanoBridge 2G18 | bullet-m | 32Mb | stable
NanoBridge 5G22/25 | bullet-m | 32Mb | stable
NanoBridge M9 | bullet-m | 32Mb | stable
NanoStation Loco M2/M5/M9 XM | bullet-m | 32Mb | stable
NanoStation Loco M2/M5 XW | loco-m-xw | 64Mb | stable
NanoStation Loco M5 XW with test date after ~Nov 2017 | rocket-m-xw | 64Mb | stable
NanoStation  M2/M3/M5 XM | nano-m | 32Mb | stable
NanoStation  M2/M5 XW | nano-m-xw | 64Mb | stable
PicoStation M2 | bullet-m | 32Mb | stable
PBE-M2-400 | loco-m-xw | 64Mb | stable
PBE-M5-300 | loco-m-xw | 64Mb | stable
PBE-M5-400/400ISO/620 | rocket-m-xw | 64Mb | stable
PowerBridge | nano-m  | 64Mb | stable
Rocket M9/M2/M3/M5/M5GPS XM | rocket-m | 64Mb | stable
Rocket M2/M5 XW | rocket-m-xw | 64Mb | stable
Rocket M2 TI | rocket-m-ti? | 64Mb | unknown
Rocket M5 TI | rocket-m-ti | 64Mb | stable
TPLink CPE210 v1.0/v1.1 | cpe210-220-v1 | 64Mb | stable
TPLink CPE210 v2.0/v3.0 | cpe210-v2 | 64Mb | stable
TPLink CPE510 v1.0/v1.1/v2.0 | cpe510-220-v1 | 64Mb | stable
Mikrotik BaseBox 2/5 | mikrotik-nand-large | 64Mb | stable
Mikrotik hAP lite 952Ui-5ac2nD | mikrotik-rb-nor-flash-16M-ac | 64Mb | stable

## Submitting Bug Reports

Please submit all issues to http://github.com/aredn/aredn_ar71xx/issues

## Developer Only Information

The AREDN firmware is based on OpenWrt with additional packages and patches.
A Makefile automates the entire process to create firmware images.

### Building with Docker
Installing the Docker environment on your windows/linux/mac machine is a pre-requisite. A docker 'container' has been pre-configured with an aredn linux build environment. Alternative instructions are below if you wish to setup your linux install with the compiler pre-requisites necessary to do the build.

To build with docker:
```
docker pull arednmesh/builder
docker run -it --name builder arednmesh/builder
```

To pull an image (or any other file) out of the docker container:
```
docker cp builder:/opt/aredn/aredn_ar71xx/firmware/targets/ar71xx/generic/<image>.bin <local directory>
```

### Build Prerequisites

Please take a look at the [OpenWrt documentation](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem)
for a complete and up to date list of packages for your operating system. 

On Ubuntu/Debian:
```
apt-get install git subversion build-essential libncurses5-dev \
  zlib1g-dev gawk unzip libxml-perl flex wget gettext quilt \
  python libssl-dev shellcheck lua5.1
```

On openSUSE:
```
zypper install --type pattern devel_basis
zypper install git subversion ncurses-devel zlib-devel gawk unzip \
  perl-libxml-perl flex wget gettext-runtime quilt python \
  libopenssl-devel shellcheck lua51
```

### Building firmware images

To obtain the source and build the firmware locally use:

```bash
git clone https://github.com/aredn/aredn_ar71xx.git
cd aredn_ar71xx
git checkout 3.18.9.0
vi config.mk # enter your callsign, etc.
# build default ubnt and tplink images
make  
# build and add mikrotik images to firmware dir
make SUBTARGET=mikrotik
```

Building the images may take minutes or hours depending on the machine.
For more details see [build options](https://openwrt.org/docs/guide-developer/build-system/use-buildsystem).  
Review the build options in config.mk: `-j <number of cores + 1>`. 
`V=s` will give more verbose error messages.

An internet connection is required during the build process. A good internet
connection can improve the build time.

You need approximately 10GB of space for the build.

### How to build prior builds of AREDN

Prior AREDN images can be rebuilt.  Replace one of the following after
the "cd aredn_ar71xx" command above:

AREDN release 3.16.2.0

```
git checkout 3.16.2.0
```

AREDN release 3.16.1.1

```
git checkout 3.16.1.1-make
```

AREDN build 176

```
git checkout 91ee867
```

Return to most current changes

```
git checkout develop
```

### Directory Layout

```
Included in the git Repo:
config.mk    <- build settings
openwrt.mk   <- which openwrt repo and branch/tag/commit to use
feeds.conf/  <- custom package feeds (edit to point to your clone of aredn_packages)
files/       <- file system in AERDN created images, most customizations go here
patches/     <- patches to openwrt go here 
scripts/     <- tests and other scripts called from the build 
configs/     <- definitions of features in the devices' kernel and what packages to include
Makefile     <- the build definition
README.md    <- this file

Created by the build:
openwrt/     <- cloned openwrt repository
firmware/    <- the build will place the images here
results/     <- code checks and other test results in jUnit xml format
```

### Patches with quilt

The patches directory contains quilt patches applied on top of the
openwrt git repo defined in config.mk. 

If a patch is not yet included upstream, it can be placed in the `patches` directory with
the `quilt` tool. Please configure `quilt` as described in 
[OpenWrt Quilt](https://openwrt.org/docs/guide-developer/build-system/use-patches-with-buildsystem).  

#### Add, modify or delete a patch

Switch to the openwrt directory:

```bash
cd openwrt
```
Now you can use the `quilt` commands.

##### Example: add a patch

```bash
quilt push -a                 # apply all patches
quilt new 008-awesome.patch   # tell quilt to create a new patch
quilt edit somedir/somefile1  # edit files
quilt edit somedir/somefile2
quilt refresh                 # creates/updates the patch file
```

## Submitting new features and patches to AREDN

The highlevel steps to submit to this repository https://github.com/aredn/aredn_ar71xx are:

1) create a github account and 'fork' this repo
2) git commit a change into your fork, e.g. http://github.com/ae6xe/aredn_ar71xx
3) create a pull request for http://github.com/aredn/aredn_ar71xx to consider your change



