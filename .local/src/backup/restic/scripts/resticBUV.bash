#!/bin/bash

#This will run Restic backups and remove snapshots according to a policy
export RESTIC_REPOSITORY=""
# need to securely provide password: https://restic.readthedocs.io/en/latest/faq.html#how-can-i-specify-encryption-passwords-automatically
export RESTIC_PASSWORD=""

# Logfile location
logFile=""

# Backup Directory ( things to backup )
BU_DIR=""

#Define a timestamp function
timestamp() {
  date "+%b %d %Y %T %Z"
}

# insert timestamp into log
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): resticBUV.bash started" | tee -a "${logFile}"

# Run Backups
restic backup "$BU_DIR" --exclude="Movies"

printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): resticBUV.bash backup completed, starting forget ..." | tee -a "${logFile}"

# Remove snapshots according to policy
# If run cron more frequently, might add --keep-hourly 24
restic forget --keep-last 3 | tee -a "${logFile}"

printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): resticBUV.bash forget completed, starting prune ..." | tee -a "${logFile}"

# Remove unneeded data from the repository
restic prune

printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): resticBUV.bash prune completed, starting check ..." | tee -a "${logFile}"

# Check the repository for errors
restic check | tee -a "${logFile}"

# insert timestamp into log
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): resticBUV.bash finished" | tee -a "${logFile}"
