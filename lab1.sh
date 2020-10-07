#!/bin/bash

PORT="${1:-8080}"

touch id.sh
echo "ID=" > id.sh

while true
do
  trap 'break' INT
  nc -lp "$PORT" -e handler.sh
done

rm id.sh

