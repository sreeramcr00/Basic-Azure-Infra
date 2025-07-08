#!/bin/bash

<<readme
Usage ./backup.sh <source> <destination>
readme

display() {
echo "Usage ./backup.sh <source> <destination>"
}
source=$1
dest=$2
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
create_backup() {
        zip -r "${dest}/backup_${timestamp}.zip" "${source}"
        echo " backups added successfully at $timestamp"
}

rotation() {
        backups=($(ls -t "${dest}/backup_"*.zip 2>/dev/null))

        if [[ "${#backups}" -gt 5 ]]; then
                echo "Performing Rotation"
        fi

        backups_to_remove=("${backups[@]:5}")
        for backup in "${backups_to_remove[@]}";
        do
                rm -f ${backup}
        done

}


if [[ $# -eq 0 ]]; then
        display
fi

create_backup
rotation


#Add a cron job if you like to
#* * * * * bash /home/learn/backup.sh /home/learn/impo /home/learn/backup