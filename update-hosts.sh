#!/bin/sh

# Clean up any stale tempfile
echo "Removing old files..."
[ -f /tmp/hosts.working ] && rm -f /tmp/hosts.working

# Awk regex to be inverse-matched as whitelist
# - SolveMedia is needed for captchas on some websites
whitelist='api.solvemedia.com|localhost'$(awk '{printf "|%s", tolower($1)}' /usr/home/whitelist.txt)

# Blacklists
blacklist='https://1hosts.cf/
https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts
https://bit.ly/AIO-adblock
https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt'

# Fetch all Blacklist Files
echo "Fetching Blacklists..."
for url in $blacklist; do
    curl --silent $url >> "/tmp/hosts.working"
done

# Including additional_zones.txt
awk '{printf "127.0.0.1 %s\n", tolower($1)}' /usr/home/additional_zones.txt >> "/tmp/hosts.working"

# Process Blacklist, Eliminiating Duplicates, Integrating Whitelist, and Converting to unbound format
echo "Processing Blacklist..."
awk -v whitelist="$whitelist" '$1 ~ /^127\.|^0\./ && $2 !~ whitelist {gsub("\r",""); print tolower($2)}' /tmp/hosts.working | sort | uniq | \
awk '{printf "server:\n", $1; printf "local-data: \"%s A 0.0.0.0\"\n", $1}' > /var/unbound/ad-blacklist.conf

# Make unbound reload config to activate the new blacklist
echo "Restarting Unbound..."
pluginctl dns

# Clean up tempfile
echo "Cleaning Up..."
rm -f '/tmp/hosts.working'
echo "Done."
