#!/bin/bash

HOST_FILE=./ansible-setup/hosts.ini
cat > $HOST_FILE <<EOF
[kafka-brokers]
EOF

for key in $(terraform output -json ip-addresses | jq -r 'keys[]')
do
  host=$(terraform output -json ip-addresses | jq ".\"$key\"")
  external_ip=$(jq -r '.external_ip' <<< $host)
  internal_ip=$(jq -r '.internal_ip' <<< $host)
  cat >> $HOST_FILE <<< "$key ansible_host=$external_ip internal_ip=$internal_ip"
done
