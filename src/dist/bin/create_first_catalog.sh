#! /bin/bash
# Copyright (c) 2016 TripAdvisor
# Licensed under the PostgreSQL License
# https://opensource.org/licenses/postgresql
set -e

cd $(dirname $0)

source config.sh

./util/create_node.sh $PRIMARY_CATALOG_HOST $PRIMARY_CATALOG_PORT $PRIMARY_CATALOG_DATABASE sql/empty_catalog.sql

if $DEV_MODE; then
  $PSQL_CATALOG -1f sql/demo_catalog_data.sql
fi

echo
echo "Log into the catalog db and configure everything properly:"
echo "  $PSQL_CATALOG"
echo "Then run ./setup_parade.sh"
