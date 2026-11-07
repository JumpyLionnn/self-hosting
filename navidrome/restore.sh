#!/usr/bin/bash

# . "$(dirname $0)/.env"
. ../gbackup.sh


# psql_backup database "$DB_USERNAME"
file_backup restore navidrome -i ./navidrome_backup.db -i ./navidrome.env

docker compose exec navidrome navidrome backup restore --backup-file ./navidrome_backup.db
rm navidrome_backup.db
