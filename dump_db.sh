#!/bin/sh

. .env

docker-compose exec db mysqldump -u ${MODX_DB_USER} --password=${MODX_DB_PASSWORD} ${MODX_DB_NAME} > db.sql
