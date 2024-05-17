#!/usr/bin/env bash

#This will run Restic backups and remove snapshots according to a policy

# Exit on failure or pipefail
set -e -o pipefail

# This variable is for convenience
REPOSITORY_ROOT_DIR="${HOME}/data/Backup/restic"

# -------------------------------------------------------------------------------
# Logfile location
# -------------------------------------------------------------------------------
logFile="${REPOSITORY_ROOT_DIR}/logs/restic_main.log"
# Rename logfile if above a specific size and start new logfile
maxsize=1000000
logFileSize=$(stat -c%s "$logFile")

if (( logFileSize > maxsize )); then
  echo "Size of $logFile = $logFileSize bytes. Backing it up and creating new file." | tee -a "${logFile}"
  mv "$logFile" "${logFile%.*}_old.log"
  touch $logFile
fi

# -------------------------------------------------------------------------------
# Repository Location ( where to backup )
# -------------------------------------------------------------------------------
export RESTIC_REPOSITORY="${REPOSITORY_ROOT_DIR}/repos/Main"
# need to securely provide password: https://restic.readthedocs.io/en/latest/faq.html#how-can-i-specify-encryption-passwords-automatically
export RESTIC_PASSWORD="password"

# -------------------------------------------------------------------------------
# Backup Location ( things to backup )
# -------------------------------------------------------------------------------
# This variable is for convenience
BACKUP_ROOT_DIR="${HOME}"
# Single/Multiple backup targets in array
declare -a BACKUP_TARGETS=( "${BACKUP_ROOT_DIR}/Documents" "${BACKUP_ROOT_DIR}/Work" )
# Specify tags for backup targets in above array
declare -a BACKUP_TAGS=( "Main_Docs" "Main_Work" )
# Specify exclude file location(with exclude patterns) for backup targets in above array
EXCLUDE_FILES=( --exclude-file="${BACKUP_ROOT_DIR}/Documents/backup_excludes.txt" --exclude-file="${BACKUP_ROOT_DIR}/Work/backup_excludes.txt" )

# -------------------------------------------------------------------------------
# How many backups to keep.
# -------------------------------------------------------------------------------
RETENTION_LATEST=3
RETENTION_HOURS=2
RETENTION_DAYS=7
RETENTION_WEEKS=4
RETENTION_MONTHS=12
RETENTION_YEARS=2

#Define a timestamp function
timestamp() {
  date "+%b %d %Y %T %Z"
}

SCRIPT_NAME="restic main"

# -------------------------------------------------------------------------------
# Start the process
# -------------------------------------------------------------------------------
printf "\n\n" | tee -a "${logFile}"
echo "###############################################################################" | tee -a "${logFile}"
echo "$(timestamp): ${SCRIPT_NAME} started" | tee -a "${logFile}"
echo "###############################################################################" | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): Backup started." | tee -a "${logFile}"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

# Run Backups
for idx in ${!BACKUP_TARGETS[@]}
do
  restic backup --exclude-caches --tag "${BACKUP_TAGS[$idx]}" "${EXCLUDE_FILES[$idx]}" "${BACKUP_TARGETS[$idx]}" | tee -a "${logFile}"
done

printf "\n" | tee -a "${logFile}"

echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): Backup completed." | tee -a "${logFile}"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): Forget started." | tee -a "${logFile}"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

# Remove snapshots according to policy
restic forget --keep-last $RETENTION_LATEST --keep-hourly $RETENTION_HOURS --keep-daily $RETENTION_DAYS --keep-weekly $RETENTION_WEEKS --keep-monthly $RETENTION_MONTHS --keep-yearly $RETENTION_YEARS | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): Forget completed." | tee -a "${logFile}"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): Prune started." | tee -a "${logFile}"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

# Remove unneeded data from the repository
restic prune | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): Prune completed." | tee -a "${logFile}"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): Check started." | tee -a "${logFile}"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

# Check the repository for errors
restic check --read-data | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"
echo "$(timestamp): Check completed." | tee -a "${logFile}"
echo "-------------------------------------------------------------------------------" | tee -a "${logFile}"

printf "\n" | tee -a "${logFile}"

echo "###############################################################################" | tee -a "${logFile}"
echo "$(timestamp): ${SCRIPT_NAME} finished" | tee -a "${logFile}"
echo "###############################################################################" | tee -a "${logFile}"
printf "\n\n" | tee -a "${logFile}"

