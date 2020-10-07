#!/bin/bash

source id.sh

read http_type path _
z=read
while [ ${#z} -gt 2 ]
do
  read z
done

resp_http="HTTP/1.1"

if [ $http_type == "GET" ]
then
  if [ -z $ID ]
  then
    echo -e "$resp_http 404 Not Found\n\nID not found"
  else
    resp_0=$(curl -s -w "\n%{http_code}" "https://docs.google.com/spreadsheets/d/$ID/gviz/tq?tqx=out:csv")
    resp=($resp_0)
    code=${resp[-1]}
    if [ $code == "200" ]
    then
      res=${resp_0:0:${#resp_0}-3}
      echo -e "$resp_http 200 OK\r\ncontent-type: text/csv; charset=utf-8\r\ncontent-disposition: attachment; filename='data.csv'; filename*=UTF-8''data.csv\r\n"
      echo "$res"
    else
      echo -e "$resp_http 400\n\nUnknow Error, code $code\n"
    fi
  fi
elif [ $http_type == "PUT" ]
then
  echo -e "$resp_http 200 OK\r\n"
  IFS='/' read -ra tmp <<< $path
  ID=${tmp[1]}
  echo "$ID"
  echo "ID=$ID" > id.sh
else
  echo -e "$resp_http 405 Method Not Allowed\n\n405\n"
fi
