#!/bin/bash
set -e

current="$(curl -sSL 'https://api.github.com/repos/modxcms/revolution/tags' | sed -n 's/^.*"name": "v\([^"]*\)-pl".*$/\1/p' | head -n1)"

curl -o modx.zip -sSL https://modx.com/download/direct/modx-$current-pl.zip

sha1="$(sha1sum modx.zip | sed -r 's/ .*//')"

for variant in apache fpm; do
	(
		set -x

		sed -ri '
			s/^(ENV MODX_VERSION) .*/\1 '"$current"'/;
			s/^(ENV MODX_SHA1) .*/\1 '"$sha1"'/;
		' "$variant/Dockerfile"

		cp docker-entrypoint.sh "$variant/docker-entrypoint.sh"
	)
done

rm modx.zip
