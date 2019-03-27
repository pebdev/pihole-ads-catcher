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
- write a blacklist file (into the ads-catcher/blacklist folder)
- add this file to pi-hole blacklist (if it's not yet done)
- launch pi-hole update to take account of new adresses

Note : backup of the previous blacklist file (into the ads-catcher/blacklist folder) is done each time a new blacklist file is written. You can find these backup into ads-catcher/history.

This system needs time to remove ads but it has advantage to do the job alone.


### Installation ###

For the moment, you must install **ads-catcher.sh** script into this directory :

	/opt/tools/ads-catcher/


Add cron task by editing **/etc/crontab** file :

	*/5 * * * * root /opt/tools/ads-catcher/ads-catcher.sh > /tmp/ads-catcher.log 2>&1


### Known issues ###
- no issues


### Link ###

Discussion on pi-hole forum : [link](https://discourse.pi-hole.net/t/how-do-i-block-ads-on-youtube/253/327)
