#!/bin/sh
BACKUP_FILE="/docker-entrypoint-initdb.d/backup.dump"
if [ -f "$BACKUP_FILE" ]; then
  pg_restore --verbose --clean --no-acl --no-owner -U postgres -d postgres "$BACKUP_FILE"
fi
exit