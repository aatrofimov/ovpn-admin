#!/usr/bin/env bash

docker build . --iidfile iiffile

image_id=$(cat iiffile)
DIR1=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c10)
DIR2=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c10)

docker save "${image_id}" > _out.tar && \
mkdir "$DIR1" && mkdir "$DIR2" && \
tar -xvf _out.tar -C "$DIR1" && \
rm _out.tar -f && rm iiffile -f

cd "$DIR1" || exit 1

for d in */ ; do
    [ -L "${d%/}" ] && continue
    echo "$d"
    tar -xvf "$d"/layer.tar -C ../"$DIR2"
done

cd ..

rm "$DIR1" -rf

cp "$DIR2"/app/ovpn-admin ovpn-admin

rm "$DIR2" -rf
