#!/usr/bin/bash

. "$(dirname $0)/.env"
bash ~/gbackup.sh backup immich -i "$UPLOAD_LOCATION" --exclude "$UPLOAD_LOCATION/thumbs/" --exclude "$UPLOAD_LOCATION/encoded-video/" --pgsql "database,$DB_USERNAME"

# . "$(dirname "$0")/.env"
# . ~/.env
# export BORG_PASSPHRASE
#
# BORG_REPO="$BORG_REMOTE_HOST/$BORG_REMOTE_BACKUP_PATH/immich"
# if ! borg version "$BORG_REPO" &> /dev/null; then
#     echo "Repository does not exist, creating..."
#     borg init --make-parent-dirs --encryption=repokey-blake2 "$BORG_REPO" &> /dev/null
#     borg key export "$BORG_REPO" ./borg_encryped_key.txt
# fi
#
#
#
# ### Local
#
# # Backup Immich database
# mkdir -p "$UPLOAD_LOCATION"/database-backup/
# docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=$DB_USERNAME | zstd -10 --force -o "$UPLOAD_LOCATION"/database-backup/immich-database.sql.zstd
# For deduplicating backup programs such as Borg or Restic, compressing the content can increase backup size by making it harder to deduplicate. If you are using a different program or still prefer to compress, you can use the following command instead:
# docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=<DB_USERNAME> | /usr/bin/gzip --rsyncable > "$UPLOAD_LOCATION"/database-backup/immich-database.sql.gz

### Append to local Borg repository
#borg create "$BACKUP_PATH/immich-borg::{now}" "$UPLOAD_LOCATION" --exclude "$UPLOAD_LOCATION"/thumbs/ --exclude "$UPLOAD_LOCATION"/encoded-video/
#borg prune --keep-weekly=4 --keep-monthly=3 "$BACKUP_PATH"/immich
#borg compact "$BACKUP_PATH"/immich


### Append to remote Borg repository
# borg create "$BORG_REPO::{now}" "$UPLOAD_LOCATION" --compression auto,zstd,10 --progress --exclude "$UPLOAD_LOCATION"/thumbs/ --exclude "$UPLOAD_LOCATION"/encoded-video/
# borg prune --keep-weekly=4 --keep-monthly=3 "$BORG_REPO"
# borg compact "$BORG_REPO"
#
# unset BORG_PASSPHRASE
