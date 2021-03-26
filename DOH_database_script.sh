#!/bin/sh

# Set Colors
C_NONE='\e[0m'
C_RED='\e[1;31m'
C_GREEN='\e[1;32m'

# Determing location for script to output files
if [ -z "$1" ]
	then
		if whiptail --title "Output Folder" --yesno "Do you want the IP List to output in the current location" "${r}" "${c}";
			then
			whiptail --msgbox --title "Output Folder" "Outputting to current location" "${r}" "${c}"
			else
			folderlocation=$(whiptail --title "Set Output Folder" --inputbox "Please set an output location for the IP List." "${r}" "${c}" "${folderlocation}" 3>&1 1>&2 2>&3) || \
			{ echo "${C_RED}Cancel was selected, exiting script${C_NONE}"; exit 1; }
			printf "The output folder location will be: ${C_GREEN}%s${C_NONE}"\\n "${folderlocation}"
		fi
	else
		folderlocation="$1"
fi
# Create and set directory for file file creation
if [ -n "$folderlocation" ]
	then
		mkdir -p $folderlocation && cd $folderlocation
fi
# Fetch database from github
curl -L --output DOH.db https://github.com/jpgpi250/piholemanual/blob/master/DOH.db?raw=true
echo "DOH.db ${C_GREEN}retrieved${C_NONE}"
# Retrieve unique domains from database that match the latest timestamp and output to file
sqlite3 DOH.db \
"select DISTINCT domain from 'domainlist' \
where domainlist.timestamp = \
(select value from info where property = 'latest_timestamp');" > DOH.txt
echo "DOH.txt ${C_GREEN}created${C_NONE}"
#Dig for IPs
dig -f DOH.txt +tries=3 +time=5 @192.168.0.6 -p 53 +short > DOHdig.txt
echo "DOHdig.txt ${C_GREEN}completed${C_NONE}"
# Strip output of dig to just IPs and output to file
grep -E '(([0-9]|[0-9]{2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[0-9]{2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])' DOHdig.txt > DOHips.txt
echo "DOHips.txt ${C_GREEN}created${C_NONE}"
# Sort list of IPs and output to file
sort -o DOHsort.txt DOHips.txt
echo "DOHsort.txt ${C_GREEN}created${C_NONE}"
# Output only unique IPs to file
uniq DOHsort.txt DOHdup.txt
echo "DOHdup.txt ${C_GREEN}created${C_NONE}"
# Remove any IPs that begin with 0.* and output to file
grep -E -v '^0\..{0,11}$' DOHdup.txt > DOHip4.txt
wc -l DOHip4.txt
# Remove all create files except finaly list of IPs
rm -f DOH.db
echo "DOH.db ${C_GREEN}removed${C_NONE}"
rm -f DOH.txt
echo "DOH.txt ${C_GREEN}removed${C_NONE}"
rm -f DOHdig.txt
echo "DOHdig.txt ${C_GREEN}removed${C_NONE}"
rm -f DOHips.txt
echo "DOHips.txt ${C_GREEN}removed${C_NONE}"
rm -f DOHvips.txt
echo "DOHvips.txt ${C_GREEN}removed${C_NONE}"
rm -f DOHsort.txt
echo "DOHsort.txt ${C_GREEN}removed${C_NONE}"
rm -f DOHdup.txt
echo "DOHdup.txt ${C_GREEN}removed${C_NONE}"
