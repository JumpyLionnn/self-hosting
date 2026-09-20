#!/usr/bin/bash

# . "$(dirname $0)/.env"
# bash ~/gbackup.sh restore authentik -i ./.env -i ./certs -i ./custom-templates -i ./data --pgsql "postgresql,$DB_USERNAME"
. ../gbackup.sh
echo "Restoring files"
file_backup restore authentik -i ./.env -i ./certs -i ./custom-templates -i ./data -i ./database-backup

echo "Restoreing Database"
ls -A ./
. "$(dirname $0)/.env"
psql_restore postgresql "$DB_USERNAME"
# read_key() {
#     local -n rkey="$1"
#     read -rsn1 rkey  # Read first byte (escape)
#     if [[ "$rkey" == $'\e' ]]; then
#         local escape_seq=""
#         read -rsn2 -t 0.04 escape_seq # Read next 2 bytes (e.g., [A)
#         rkey+=$escape_seq
#     fi
# }
#
#
# # Clears n lines after the cursor inclusive
# clear_lines() {
#     local n=$1
#     for i in $(seq $n)
#     do
#         echo -en "\e[2K\e[1B" # clear the current line and go the next one
#     done
#     echo -en "\e[2K\e[${n}A" # clear the current line and go back to the top
# }
#
# selection_menu() {
#     local -r prompt="$1" outvar="$2" options=("${@:3}")
#     local cur=0 count=${#options[@]} index=0
#     local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
#     printf "$prompt\n"
#     while true
#     do
#         # list all options (option list is zero-based)
#         index=0 
#         for o in "${options[@]}"
#         do
#             if [ "$index" == "$cur" ]
#             then echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
#             else echo "  $o"
#             fi
#             (( ++index ))
#         done
#         #read -s -n3 key # wait for user to key in arrows or ENTER
#         read_key key
#         if [[ $key == "$esc[A" || $key == "k" ]] then # up arrow
#             (( cur-- )); 
#             (( cur < 0 )) && (( cur = 0 ))
#         elif [[ $key == "$esc[B" || "$key" == "j" ]] then # down arrow
#             (( ++cur )); 
#             (( cur >= count )) && (( cur = count - 1 ))
#         elif [[ $key == "" ]] then # nothing, i.e the read delimiter - ENTER
#             break
#         fi
#         echo -en "\e[${count}A" # go up to the beginning to re-render
#     done
#
#     echo -en "\e[${count}A" # go up to the beginning to clear
#     clear_lines $(($count + 1))
#
#     # export the selection to the requested output variable
#     printf -v $outvar "${options[$cur]}"
# }
#
# yes_no() {
#     echo -n "$1 "
#     local res=""
#     read -r res
#     local res=$(tr "[:upper:]" "[:lower:]" <<< $res)
#     if [[ $res != "yes" && $res != "y" && $res != "true" && $res != "go on" && $res != "continue" && $res != "sure" && $res != "confirm" ]]; then
#         return 1 
#     else
#         return 0
#     fi
# }
#
# mk() {
#     path="$1"
#     name=$(basename "$path")
#     if [[ "$name" == *"."* ]]; then
#         mkdir -p $(dirname "$path")
#         touch "$path"
#     else
#         mkdir -p "$path"
#     fi
# }
#
# . "$(dirname "$0")/.env"
# . "~/.env"
# export BORG_PASSPHRASE
#
#
# NAME="authentik"
# DB_CONTAINER_NAME="postgresql"
#
# BORG_REPO="$BORG_REMOTE_HOST/$BORG_REMOTE_BACKUP_PATH/$NAME"
#
# list=$(borg list --sort-by timestamp --format "'{name:}'   created by {hostname} at {time}{NEWLINE}" "$BORG_REPO")
# mapfile -t names <<< $list
#
# selection_menu "Please choose the archive to restore:" selected_option "${names[@]}"
# archive_name=$(grep -Po "(?<=')[0-9\-\:T]+(?=')" <<< "$selected_option")
#
# echo "'$archive_name' will be restored."
# if yes_no "Would you like to backup the current state?"; then
#     echo "Backing up..."
#     bash ./backup.sh
# else
#     if ! yes_no "Are you sure you want to restore the backup (The current state will become unrecoverable)?"; then
#         exit 1
#     fi
# fi
#
#
# echo "Extracting"
# borg extract "$BORG_REPO::$archive_name"
#
#
# docker compose down
# docker compose up -d $DB_CONTAINER_NAME 
#
# echo "Restoring Database"
# zstd --decompress --stdout "./database-backup/$NAME-database.sql.zstd" | docker exec -i $DB_CONTAINER_NAME psql --username "$DB_USERNAME" 1> /dev/null
# #--username=$DB_USERNAME > "$UPLOAD_LOCATION"/database-backup/immich-database.sql
# #docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=$DB_USERNAME > "$UPLOAD_LOCATION"/database-backup/immich-database.sql
# #cd "$working_dir"
#
#
# unset BORG_PASSPHRASE
