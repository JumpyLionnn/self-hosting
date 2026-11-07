#!/usr/bin/bash

# . "$(dirname $0)/.env"
. ../gbackup.sh


# psql_backup database "$DB_USERNAME"
docker compose exec navidrome navidrome backup create -d /data/backups/
cp ./data/backups/navidrome_backup* ./navidrome_backup.db

# Delete all backups
docker compose exec navidrome navidrome backup prune -d /data/backups/ -k 0 -f

file_backup backup navidrome -i ./navidrome_backup.db -i ./navidrome.env

rm navidrome_backup.db
