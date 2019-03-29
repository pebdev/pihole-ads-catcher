# Pi-Hole #

## ads-catcher ##
	
### What is it ? ###

This tool scans pi-hole logfiles to find youtube address of ads servers. It updates pi-hole blacklist automatically after a scan.


### How it works ? ###

This tool is called (by cron) every 10 minutes to check pi-hole logfiles.
It does following actions :

- scan pihole logfiles
- extract addresses of ads servers
- filter result (to remove duplicated addresses, whitlist addresses, etc.)
- add blacklisted addresses to pihole list
- launch pi-hole update to take account of new adresses

<span style="color:red">This system needs time to remove ads but it has advantage to do the job alone, be patient.</span>


### Installation ###

Debian package is provided, you just need to download it ([release page](https://github.com/pebdev/pihole/releases)), and to launch dpkg :

	sudo dpkg -i <deb_file>

Content of the package :

	 /
	 ├── /etc/ads-catcher.cfg
	 ├── /usr/bin/ads-catcher
	 ├── /usr/share/doc/ads-catcher/copyright
	 ├── /usr/share/man/man1/ads-catcher.1.gz

Note : you can see content with this command **dpkg -c < deb_file >**


### Uninstall ###

To uninstall this package, just lanch this command :

	sudo dpkg -r ads-catcher


### Configuration ###

Configuration file location : **/etc/ads-catcher.cfg**

	# If enabled, ads-catcher creates independent file to add blacklisted
	# addresses for eache services (youtube, etc.) and add link of these
	# files to the pi-hole blacklist file.
	# If disabled, ads-catcher writes blacklisted addresses directly inside
	# pi-hole blacklist file.
	#
	# Values  : 0=disabled | 1=enabled
	# Default : 0
	#
	blacklist_seperated_files=0
	
	
	# With this feature, ads-catcher creates a backup file of blacklisted
	# addresses each time that it add new addresses.
	# With it, you can find latest addresses that have been added.
	# Backup files are stored into : <root_script_path>/backup/
	# Filename : <service>_<number-of-addresses>.txt
	#
	# Values  : 0=disabled | 1=enabled
	# Default : 0
	#
	blacklist_backup=0


### Logfile ###

If you want to check actions of the script you can access to the logfile :

	cat /var/log/ads-catcher.log


### Known issues ###

- no issues


### Link ###

Discussion on pi-hole forum : [link](https://discourse.pi-hole.net/t/how-do-i-block-ads-on-youtube/253/327)



## Changelog ##
**v1.1.0** *[md5:8ce40ab7ec66ff37406317cf2676d9eb]*   
- [ADDED] option to write (1) ads-catcher blacklist files or (2) blocked addresses into the pi-hole balcklist (default: (2))  
- [ADDED] option to enable/disable backup files (default : disabled)   
- [ADDED] configuration file  
- [ADDED] deb package for easy install

**v1.0.0**   
- initial revision