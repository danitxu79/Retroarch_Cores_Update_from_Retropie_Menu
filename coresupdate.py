#!/usr/bin/env python3

# user's retroarch configuration file
retroconfig = '/opt/retropie/configs/all/retroarch.cfg'

# current buildbot url
retrourl = 'https://buildbot.libretro.com'

import argparse
import configparser
import os
import os.path as pth
import platform
import shutil
import sys
import tempfile
import time
import urllib.request
import zipfile

# parse arguments
pars = argparse.ArgumentParser()

pars.add_argument('-c', '--cores', action="store_true",
                  help='download and extract cores')

pars.add_argument('-s', '--assets', action="store_true",
                  help='download and extract asset files')

pars.add_argument('-a', '--all', action="store_true",
                  help='download and extract both')

pars.add_argument('-v', '--verbose', action="store_true",
                  help='display target urls and directories')

pars.add_argument('-d', '--dry', action="store_true",
                  help='dry run; do not download anything')

pars.add_argument('-g', '--config', type=str,
                  help='specify the retroarch config file')

args = pars.parse_args(args=None if sys.argv[1:] else ['-h'])

if args.all:
    args.assets = True
    args.cores = True


(echo raspberry | sudo -S apt-get install dialog -y)

# while-menu-dialog: a menu driven system information program

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "System Information" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Update all cores installaed:" $HEIGHT $WIDTH 4 \
    "1" "update all installed cores\
    "2" "Install and update all cores" \
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
    1 )
      result=$(echo "Hostname: $HOSTNAME"; uptime)
      display_result "SUpdate installed cores"
      ;;# asset names used in the buildbot and config file
itemlist = {
    'assets'           : 'assets_directory',
    'autoconfig'       : 'joypad_autoconfig_dir',
    'cheats'           : 'cheat_database_path',
    'database-cursors' : 'cursor_directory',
    'database-rdb'     : 'content_database_path',
    'info'             : 'libretro_info_path',
    'overlays'         : 'overlay_directory',
    'shaders_cg'       : 'video_shader_dir',
    'shaders_glsl'     : 'video_shader_dir',
    'shaders_slang'    : 'video_shader_dir',
}

# get platform
if sys.platform == 'win32':
    osname = 'windows'
    time.timezone = 0
elif sys.platform == 'darwin':
    osname = 'apple/osx'
else:
    osname = sys.platform

# check architecture
if platform.machine().endswith('64'):
    osarch = 'x86_64'
else:
    osarch = 'x86'

# get partial download urls
urlcores = pth.join(retrourl, 'nightly', osname, osarch, 'latest')
urlassets = pth.join(retrourl, 'assets/frontend')

# get config path; expand unix home folders
if args.config:
    retroconfig = args.config

retroconfig = pth.normcase(pth.expanduser(retroconfig))
retrodir = pth.dirname(retroconfig)

# retrieve paths from retroarch user config
with open(retroconfig, 'r') as tmpconf:

    conf = configparser.ConfigParser()
    conf.read_string('[A]\n' + tmpconf.read())

    # get asset paths; strip quotes and expand any ~'s
    for item in itemlist:
        itemlist[item] = pth.expanduser(conf['A'][itemlist[item]].strip('"'))

    # get whole path of portable folders
    if itemlist[item].startswith(':'):
        itemlist[item] = pth.join(retrodir, itemlist[item].lstrip(':\\'))

    # add subdirs to shaders' paths
    for shdr in ['shaders_cg', 'shaders_glsl', 'shaders_slang']:
        itemlist[shdr] = pth.join(itemlist[shdr], shdr)

    # and also get the cores path
    coredir = pth.expanduser(conf['A']['libretro_directory'].strip('"'))
    if coredir.startswith(':'):
        coredir = pth.join(retrodir, coredir.lstrip(':\\'))

    corelist = sorted(os.listdir(coredir))
    conf.clear()

    # download and extract archive to destination
    def fetch_archive(url, dest):

    # download
    with urllib.request.urlopen(url) as tmpdata:
        tmpfile = tempfile.NamedTemporaryFile(suffix='.zip')
        shutil.copyfileobj(tmpdata, tmpfile)

    # extract
    with zipfile.ZipFile(tmpfile, 'r') as tmpzip:
        for member in tmpzip.infolist():
            tmpzip.extract(member, dest)

            # use original modification timestamp
            origdate = time.mktime(member.date_time + (0, 0, -1)) - time.timezone
            os.utime(pth.join(dest, member.filename), (origdate, origdate))

    # download and extract each core currently in retroarch's core directory
    if args.cores:
    print('updating cores...')

    for core in corelist:
        coreurl = pth.join(urlcores, core+'.zip').replace('\\', '/')

        print('[%2d/%2d] fetching: %s' % (corelist.index(core)+1,
                                          len(corelist),
                                          core+'.zip'))
        if args.verbose:
            print(' '*7, 'from url: %s' % coreurl)
            print(' '*7, 'into dir: %s' % coredir)

        if not args.dry:
            try:
                fetch_archive(coreurl, coredir)
            except Exception as excp:
                print(' '*7, 'could not fetch file: %s' % core+'.zip')
                print(' '*7, excp)

    2 )
      result=$(df -h)
      display_result "Disk Space"
      if [[ $(id -u) -eq 0 ]]; then
        result=$(du -sh /home/* 2> /dev/null)
        display_result "Home Space Utilization (All Users)"
      else
        result=$(du -sh $HOME 2> /dev/null)
        display_result "Home Space Utilization ($USER)"
      fi
      ;;
  esac
done

clear

do
 case $seleccion in
 1)
 echo "Escogiste la opción 1"
 ;;
 2)
 echo "Escogiste la opción 2"
 ;;


# download and extract each asset archive into their respective directories
if args.assets:
    print('updating assets...')

    for item in itemlist:
        itemurl = pth.join(urlassets, item+'.zip').replace('\\', '/')
        itempath = itemlist[item]

        print('[%2d/%2d] fetching: %s' % (list(itemlist).index(item)+1,
                                          len(itemlist),
                                          item+'.zip'))
        if args.verbose:
            print(' '*7, 'from url: %s' % itemurl)
            print(' '*7, 'into dir: %s' % itempath)

        if not args.dry:
            try:
                os.makedirs(itempath, exist_ok=True)
                fetch_archive(itemurl, itempath)
            except Exception as excp:
                print(' '*7, 'could not fetch file: %s' % item+'.zip')
                print(' '*7, excp)

