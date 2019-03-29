# Pi-Hole #

## ads-catcher ##
	
### What is it ? ###

This script scan pi-hole logfiles to find youtube address of ads servers. It updates pi-hole blacklist automatically after a scan.


### How it works ? ###

To work, it's needed to add periodic call (cron task for example) to this **ads-catcher.sh** script.

Script will do these actions :

- scan pihole logfiles
- extract addresses of ads servers
- filter result (to remove duplicated addresses, whitlist addresses, etc.)
- add blacklisted addresses to pihole list
- launch pi-hole update to take account of new adresses

<span style="color:red">This system needs time to remove ads but it has advantage to do the job alone, be patient.</span>


### Installation ###

Install **ads-catcher** files into the wanted directory.    
Example :

	/opt
	 ├── tools
	     ├── ads-catcher
			  ├── ads-catcher.sh
			  ├── settings.txt


Add cron task by editing **/etc/crontab** file :

	*/10 * * * * root /opt/tools/ads-catcher/ads-catcher.sh > /tmp/ads-catcher.log 2>&1

Note : with this line, script will be launched every 10 minutes.

### Configuration ###

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

	cat /var/log/pihole.log


### Known issues ###

- no issues


### Todo ###

- create deb package for an easy installation


### Link ###

Discussion on pi-hole forum : [link](https://discourse.pi-hole.net/t/how-do-i-block-ads-on-youtube/253/327)



## Changelog ##
v1.1.0   
- [FIXED] now user can install script anywhere   
- [ADDED] option to write (1) ads-catcher blacklist files or (2) blocked addresses into the pi-hole balcklist (default: (2))  
- [ADDED] option to enable/disable backup files (default : disabled)   
- [ADDED] configuration file

v1.0.0   
- initial revision