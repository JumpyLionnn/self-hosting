#!/usr/bin/bash

# . "$(dirname $0)/.env"
. ../gbackup.sh


DIRECTORY="./data/backups"
if [ -d "$DIRECTORY" ] && [ ! -w "$DIRECTORY" ]; then
    echo "No permission to write to the ./data/backups directory" >&2
    exit 1
fi
file_backup restore navidrome -ekdjfalbgvjp -i ./navidrome_backup.db -i ./navidrome.env 

mkdir -p "$DIRECTORY"
mv -f navidrome_backup.db "$DIRECTORY/navidrome_backup.db"

docker compose down
docker compose exec navidrome navidrome backup restore --backup-file /data/backups/navidrome_backup.db
echo "restored backup"
rm "$DIRECTORY/navidrome_backup.db"
docker compose up -d
