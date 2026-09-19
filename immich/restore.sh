#!/usr/bin/bash

. "$(dirname $0)/.env"
bash ~/gbackup.sh restore immich -i "$UPLOAD_LOCATION" --exclude "$UPLOAD_LOCATION"/thumbs/ --exclude "$UPLOAD_LOCATION"/encoded-video/ --pgsql "database,$DB_USERNAME"

mk "$UPLOAD_LOCATION/thumbs/.immich"
mk "$UPLOAD_LOCATION/encoded-video/.immich"


