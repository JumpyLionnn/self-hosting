#!/usr/bin/bash

. ../gbackup.sh

file_backup restore immich -i "$UPLOAD_LOCATION" -i ./.env --exclude "$UPLOAD_LOCATION/thumbs/" --exclude "$UPLOAD_LOCATION/encoded-video/" -i ./database-backup

. "$(dirname $0)/.env"
psql_restore database "$DB_USERNAME"
# bash ~/gbackup.sh restore immich -i "$UPLOAD_LOCATION" -i ./.env --exclude "$UPLOAD_LOCATION"/thumbs/ --exclude "$UPLOAD_LOCATION"/encoded-video/ --pgsql "database,$DB_USERNAME"

mk "$UPLOAD_LOCATION/thumbs/.immich"
mk "$UPLOAD_LOCATION/encoded-video/.immich"


