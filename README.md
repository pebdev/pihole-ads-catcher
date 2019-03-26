# Pi-Hole #

## ads-catcher ##
	
This script scan pi-hole logfiles to find youtube address of ads servers. It updates ip-hole blacklist automatically after a scan.

To work, it's needed to add periodic call (cron task for example).

This system needs type to remove ads but it has advantage to do the job alone.


### Installation ###

For the moment, you must install **ads-catcher.sh** script into this directory :

	/opt/tools/ads-catcher/


Add cron task by editing **/etc/crontab** file :

	*/5 * * * * root /opt/tools/ads-catcher/ads-catcher.sh > /tmp/ads-catcher.log 2>&1


### Known issues ###
- bad filtering with some googlevide.com addresses


### Link ###

Discussion on pi-hole forum : [link](https://discourse.pi-hole.net/t/how-do-i-block-ads-on-youtube/253/327)
