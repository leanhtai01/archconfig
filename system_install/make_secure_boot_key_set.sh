#!/bin/bash

set -e

current_dir=$(dirname $0)
keys_dir=$current_dir/secure_boot_key_set

printf "Enter a name to embed in the keys: "
read NAME

mkdir $keys_dir

# create a GUID for owner identification
uuidgen --random > $keys_dir/GUID.txt

# Platform Key (PK)
openssl req -newkey rsa:4096 -nodes -keyout $keys_dir/PK.key -new -x509 -sha256 -days 3650 -subj "/CN=$NAME PK/" -out $keys_dir/PK.crt
openssl x509 -outform DER -in $keys_dir/PK.crt -out $keys_dir/PK.cer
cert-to-efi-sig-list -g "$(< $keys_dir/GUID.txt)" $keys_dir/PK.crt $keys_dir/PK.esl
sign-efi-sig-list -g "$(< $keys_dir/GUID.txt)" -k $keys_dir/PK.key -c $keys_dir/PK.crt PK $keys_dir/PK.esl $keys_dir/PK.auth

# Sign an empty file to allow removing Platform Key when in "User Mode"
sign-efi-sig-list -g "$(< $keys_dir/GUID.txt)" -c $keys_dir/PK.crt -k $keys_dir/PK.key PK /dev/null $keys_dir/rm_PK.auth

# Key Exchange Key (KEK)
openssl req -newkey rsa:4096 -nodes -keyout $keys_dir/KEK.key -new -x509 -sha256 -days 3650 -subj "/CN=$NAME KEK/" -out $keys_dir/KEK.crt
openssl x509 -outform DER -in $keys_dir/KEK.crt -out $keys_dir/KEK.cer
cert-to-efi-sig-list -g "$(< $keys_dir/GUID.txt)" $keys_dir/KEK.crt $keys_dir/KEK.esl
sign-efi-sig-list -g "$(< $keys_dir/GUID.txt)" -k $keys_dir/PK.key -c $keys_dir/PK.crt KEK $keys_dir/KEK.esl $keys_dir/KEK.auth

# Signature Database Key (db)
openssl req -newkey rsa:4096 -nodes -keyout $keys_dir/db.key -new -x509 -sha256 -days 3650 -subj "/CN=$NAME db/" -out $keys_dir/db.crt
openssl x509 -outform DER -in $keys_dir/db.crt -out $keys_dir/db.cer
cert-to-efi-sig-list -g "$(< $keys_dir/GUID.txt)" $keys_dir/db.crt $keys_dir/db.esl
sign-efi-sig-list -g "$(< $keys_dir/GUID.txt)" -k $keys_dir/KEK.key -c $keys_dir/KEK.crt db $keys_dir/db.esl $keys_dir/db.auth

chmod 0600 $keys_dir/*.key

echo ""
echo "For use with KeyTool, copy the *.auth and *.esl files to a FAT USB"
echo "flash drive or to your EFI System Partition (ESP)."
echo "For use with most UEFIs' built-in key managers, copy the *.cer files."
echo ""
