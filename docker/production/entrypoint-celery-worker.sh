#!/usr/bin/env bash

cd /app/kompass

celery -A kompass.jdav_web worker -l info
