#!/bin/bash
set -e

echo "Waiting for mysql"
until mysql -h"db" -P"3306" -uroot -p"root" &> /dev/null
do
printf "."
sleep 1
done

>&2 echo "mysql is up - executing command"
