#!/bin/bash

## find update/OSX path
cd __DEFAULTPATH__
InstallerPath=${PWD}

## find PlexConnect main path
cd ../..
PlexConnectPath=${PWD}

## go back to InstallerPath
cd update/OSX

## Copy com.plex.plexconnect.bash.plist
cp com.plex.plexconnect.bash.plist /Library/LaunchDaemons

## replace __INSTALLERPATH__, __PLEXCONNECTPATH__ in default com.plex.plexconnect.daemon.bash.plist
## save directly to the /Library/LaunchDameons folder
sed -e "s/__INSTALLERPATH__/${InstallerPath//\//\\/}/;s/__PLEXCONNECTPATH__/${PlexConnectPath//\//\\/}/" "${InstallerPath}/com.plex.plexconnect.bash.plist" > /Library/LaunchDaemons/com.plex.plexconnect.bash.plist

## create autostart plist for next boot
echo 'Installing PlexConnect...'

## unload and remove the non bash.plist if present
launchctl unload /Library/LaunchDaemons/com.plex.plexconnect.plist
rm /Library/LaunchDaemons/com.plex.plexconnect.plist

## change ownership and permissions of the plist file to make it launchctl compatible
chown root /Library/LaunchDaemons/com.plex.plexconnect.bash.plist
chmod 644 /Library/LaunchDaemons/com.plex.plexconnect.bash.plist

## start PlexConnect for this session
echo 'Starting PlexConnect...'

## launch the plist so that we can use it without a reboot
launchctl load /Library/LaunchDaemons/com.plex.plexconnect.bash.plist

## wait a couple seconds to allow PlexConnect to load
sleep 2

## display the running status of PlexConnect
#./PlexConnect_daemon.bash status
launchctl list | grep com.plex.plexconnect.bash
