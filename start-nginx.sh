#!/bin/sh

until ping -c 1 datatools-server; do
    echo "Waiting for Data Tools server..."
    sleep 5
done

exec nginx -g 'daemon off;'
