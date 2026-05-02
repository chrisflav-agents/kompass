#!/usr/bin/env bash

set -o errexit

cd /app

if ! [ -f completed_initial_run ]; then
    echo 'Initialising kompass master container'

    cd docs
    make html
    cp -r build/html /app/kompass/static/docs
    cd /app

    python kompass/manage.py collectstatic --noinput
    python kompass/manage.py compilemessages --locale de

    python kompass/manage.py migrate
    python kompass/manage.py ensuresuperuser

    # Populate test data on staging environments only
    if [ "$POPULATE_TEST_DATA" = "true" ]; then
        echo 'Populating test data for staging environment...'
        python kompass/manage.py populate_test_data
    fi

    touch completed_initial_run
fi

uwsgi --ini docker/production/kompass.uwsgi.ini
