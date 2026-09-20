#!/usr/bin/bash
. "$(dirname $0)/.env"
. ../gbackup.sh

psql_backup postgresql "$DB_USERNAME"
file_backup backup authentik -i ./.env -i ./certs -i ./custom-templates -i ./data -i ./database-backup
# bash ~/gbackup.sh backup authentik -i ./.env -i ./certs -i ./custom-templates -i ./data --pgsql "postgresql,$DB_USERNAME"
