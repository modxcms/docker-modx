#!/bin/bash
set -e

if [[ "$1" == apache2* ]] || [ "$1" == php-fpm ]; then
	if [ -n "$MYSQL_PORT_3306_TCP" ]; then
		if [ -z "$MODX_DB_HOST" ]; then
			MODX_DB_HOST='mysql'
		else
			echo >&2 'warning: both MODX_DB_HOST and MYSQL_PORT_3306_TCP found'
			echo >&2 "  Connecting to MODX_DB_HOST ($MODX_DB_HOST)"
			echo >&2 '  instead of the linked mysql container'
		fi
	fi

	if [ -z "$MODX_DB_HOST" ]; then
		echo >&2 'error: missing MODX_DB_HOST and MYSQL_PORT_3306_TCP environment variables'
		echo >&2 '  Did you forget to --link some_mysql_container:mysql or set an external db'
		echo >&2 '  with -e MODX_DB_HOST=hostname:port?'
		exit 1
	fi

	# if we're linked to MySQL and thus have credentials already, let's use them
	: ${MODX_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}
	if [ "$MODX_DB_USER" = 'root' ]; then
		: ${MODX_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
	fi
	: ${MODX_DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
	: ${MODX_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-modx}}

	if [ -z "$MODX_DB_PASSWORD" ]; then
		echo >&2 'error: missing required MODX_DB_PASSWORD environment variable'
		echo >&2 '  Did you forget to -e MODX_DB_PASSWORD=... ?'
		echo >&2
		echo >&2 '  (Also of interest might be MODX_DB_USER and MODX_DB_NAME.)'
		exit 1
	fi

	if ! [ -e index.php ]; then
		echo >&2 "MODX not found in $(pwd) - copying now..."

		if [ "$(ls -A)" ]; then
			echo >&2 "WARNING: $(pwd) is not empty - press Ctrl+C now if this is an error!"
			( set -x; ls -A; sleep 10 )
		fi

		tar cf - --one-file-system -C /usr/src/modx . | tar xf -

    echo >&2 "Complete! MODX has been successfully copied to $(pwd)"

    # TODO: Install MODX
  else
    # TODO: Check version and upgrade if it is neeeded
	fi

  php /createdb.php "$MODX_DB_HOST" "$MODX_DB_USER" "$MODX_DB_PASSWORD" "$MODX_DB_NAME"
fi

exec "$@"
