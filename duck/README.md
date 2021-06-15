If you want to have a dynamic DNS point to your Public IP I added a helper script. Register with duckdns.org and create a subdomain name. Then edit the nano ~/duck/duck.sh file and add your


DOMAINS="YOUR_DOMAINS"
DUCKDNS_TOKEN="YOUR_DUCKDNS_TOKEN"
first test the script to make sure it works sudo ~/duck/duck.sh then cat /var/log/duck.log. If you get KO then something has gone wrong and you should check out your settings in the script. If you get an OK then you can do the next step.

Create a cron job by running the following command crontab -e

You will be asked to use an editor option 1 for nano should be fine paste the following in the editor */5 * * * * /opt/duck/duck.sh then ctrl+s and ctrl+x to save

Your Public IP should be updated every five minutes
