#!/usr/bin/env bash

cd /app/kompass

celery -A kompass.jdav_web beat --scheduler django_celery_beat.schedulers:DatabaseScheduler -l info
