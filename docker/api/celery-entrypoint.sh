#!/bin/bash
set -euo pipefail

# Read entrypoint parameters.
CELERY_COMMAND=${1:-worker}

# Define variables.
: ${RYR_API_CELERY_APP:=api.celery}
: ${RYR_API_CELERY_LOG_LEVEL:=info}
: ${RYR_API_CELERY_USER:=celery}

# Run the worker as another user or not.
if [ "${RYR_API_CELERY_USER}" == "bash" ]; then
  USER_CMD="bash"
else
  USER_CMD="su -m celery"
fi

# Start Celery command.
DATE=$(date -u +%Y%m%dT%H%M%S%Z)
 "${USER_CMD}" -c "celery ${CELERY_COMMAND} \
  -A ${RYR_API_CELERY_APP} \
  -l ${RYR_API_CELERY_LOG_LEVEL} \
  --pidfile=celery_${CELERY_COMMAND}-${DATE}.pid"
