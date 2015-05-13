#! /bin/bash

# This script is a convenience script for doing the initial setup of a node
# regardless of node type

set -e

HOST=$1
PORT=$2
DATABASE=$3
SETUP_SQL=$4

PSQL_GLOBAL="psql -h $HOST -p $PORT -U $ADMIN_USER"

if $RECREATE_EXISITING_NODES; then
  $PSQL_GLOBAL -c "DROP DATABASE IF EXISTS $DATABASE;"
fi

$PSQL_GLOBAL -c "CREATE DATABASE $DATABASE;"

psql -h $HOST -p $PORT -U $ADMIN_USER $DATABASE -1 -f $SETUP_SQL
