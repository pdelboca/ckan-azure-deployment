#!/bin/bash
set -e

# Run any startup scripts
if [[ -d "./docker-entrypoint.d" ]]
then
  for f in ./docker-entrypoint.d/*; do
    case "$f" in
      *.sh)     echo "$0: Running init file $f"; . "$f" ;;
      *.py)     echo "$0: Running init file $f"; python3 "$f"; echo ;;
      *)        echo "$0: Ignoring $f (not an sh or py file)" ;;
    esac
  done
else
  echo "No directory"
fi

# Start ssh service to connect to Azure
service ssh start

# Execute gunicorn pointing to CKAN's wsgi application
exec gunicorn -w 4 -b 0.0.0.0:80 wsgi:application