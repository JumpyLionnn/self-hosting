#!/usr/bin/bash


dirpath="$(realpath "$(dirname "$BASH_SOURCE")")"
. "$dirpath/utilities.sh"

file_backup_usage="
Easy backup creation and restoration using borg

$(basename $0) backup/restore repo_name [arguments]

modes:
    backup                                      create a new backup
    restore                                     restore an existing backup

arguments:
    -i/--include <path>                         add a path to the backup (NOTE: only used for backup)
    -e/--exclude <path>                         exclude a path from the backup (NOTE: only used for backup)
"

file_backup() {
    case $1 in
        -h|--help)
            echo "$file_backup_usage"
            exit 0
            ;;
        backup)
            MODE="backup"
            shift # past argument
            ;;
        restore)
            MODE="restore"
            shift # past argument
            ;;
        *)
            echo "Unknown option $1, use --help for more info"
            exit 1
            ;;
    esac
    case $1 in
        -h|--help)
            echo "$file_backup_usage"
            exit 0
            ;;
        -*|--*)
            echo "Unknown flag $1"
            exit 2
            ;;
        *)
            NAME="$1"
            shift
            ;;
    esac

    . "$dirpath/.env"
    export BORG_PASSPHRASE
    BORG_REPO="$BORG_REMOTE_HOST/$BORG_REMOTE_BACKUP_PATH/$NAME"


    case $MODE in
        backup)
            create_backup "$@"
            ;;
        restore)
            restore_backup "$@"
            ;;
    esac

    unset BORG_PASSPHRASE
}

psql_backup() {
    CONTAINER_NAME="$1"
    DB_USERNAME="$2"
    echo "Backing up $CONTAINER_NAME"
    mkdir -p database-backup
    docker compose up -d "$CONTAINER_NAME"

    docker compose exec -t $CONTAINER_NAME pg_dumpall --clean --if-exists --username=$DB_USERNAME | zstd -19 --force -o ./database-backup/$CONTAINER_NAME-database.sql.zstd
    has_database=true
}

psql_restore() {
    CONTAINER_NAME="$1"
    DB_USERNAME="$2"
    echo "Restoring database $CONTAINER_NAME"
    docker compose up -d "$CONTAINER_NAME"

    zstd --decompress --stdout "./database-backup/$CONTAINER_NAME-database.sql.zstd" | docker exec -i $CONTAINER_NAME psql --username "$DB_USERNAME" 1> /dev/null
}


create_backup() {
    if ! borg version "$BORG_REPO" &> /dev/null; then
        echo "Repository does not exist, creating..."
        borg init --make-parent-dirs --encryption=repokey-blake2 "$BORG_REPO" &> /dev/null
        borg key export "$BORG_REPO" ./borg_encryped_key.txt
    fi

    local borg_flags=()

    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--include)
                borg_flags=("$2" "${borg_flags[@]}")
                shift # past argument
                shift # past value
                ;;
            -e|--exclude)
                borg_flags+=("--exclude" "$2")
                shift # past argument
                shift # past value
                ;;
            *)
                echo "Unknown argument $1"
                exit 1
                ;;
        esac
    done

    echo "flags: ${borg_flags[*]}"
    borg create "$BORG_REPO::{now}" ${borg_flags[*]} --compression auto,zstd,10 --progress
    borg prune --keep-weekly=4 --keep-monthly=6 --keep-daily=2 "$BORG_REPO"
    borg compact "$BORG_REPO"
}

restore_backup() {
    if ! borg version "$BORG_REPO" &> /dev/null; then
        echo "Repository does not exist"
        exit 1
    fi
    list=$(borg list --sort-by timestamp --format "'{name:}'   created by {hostname} at {time}{NEWLINE}" "$BORG_REPO")
    mapfile -t names <<< $list

    selection_menu "Please choose the archive to restore:" selected_option "${names[@]}"
    archive_name=$(echo "$selected_option" | grep -Po "(?<=')[0-9\-\:T]+(?=')")

    echo "'$archive_name' will be restored."
    if yes_no "Would you like to backup the current state?"; then
        echo "Backing up..."
        create_backup
    else
        if ! yes_no "Are you sure you want to restore the backup (The current state will become unrecoverable)?"; then
            exit 1
        fi
    fi

    # Making sure services won't interrupt the extraction
    docker compose down

    echo "Extracting..."
    borg extract "$BORG_REPO::$archive_name"



    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--include)
                # ignored
                shift # past argument
                shift # past value
                ;;
            -e|--exclude)
                # ignored
                shift # past argument
                shift # past value
                ;;
            *)
                echo "Unknown argument $1"
                exit 1
                ;;
        esac
    done

}


