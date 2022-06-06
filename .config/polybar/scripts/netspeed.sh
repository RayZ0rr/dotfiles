#!/usr/bin/env bash
#
# Depends on:
#   https://github.com/sivel/speedtest-cli

# speedtest(){
#   ~/.local/bin/speedtest-cli --simple --bytes | grep -i "$1" | awk '{for (i=2; i<=NF; i++) printf $i FS}'
# }
# ping=$(~/.local/bin/speedtest-cli --simple --bytes | grep -i ping | awk '{for (i=2; i<=NF; i++) printf $i FS}')
# download=$(~/.local/bin/speedtest-cli --simple --bytes | grep -i ping | awk '{for (i=2; i<=NF; i++) printf $i FS}')
# upload=$(~/.local/bin/speedtest-cli --simple --bytes | grep -i ping | awk '{for (i=2; i<=NF; i++) printf $i FS}')

~/.local/bin/speedtest-cli --simple --bytes > /tmp/myNetSpeed.txt
getinfo(){
  grep -i "$1" /tmp/myNetSpeed.txt | awk '{printf $2 FS}'
  # grep -i "$1" /tmp/myNetSpeed.txt | awk '{for (i=2; i<=NF; i++) printf $i FS}'
}

ping=$(getinfo ping)
download=$(getinfo download)
upload=$(getinfo upload)

printf " %sMB/s  %sMB/s" "$download" "$upload"
