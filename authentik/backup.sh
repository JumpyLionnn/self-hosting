#!/usr/bin/bash
. "$(dirname $0)/.env"
bash ~/gbackup.sh backup authentik -i ./.env -i ./certs -i ./custom-templates -i ./data --pgsql "postgresql,$DB_USERNAME"
