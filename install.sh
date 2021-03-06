#! /bin/bash
# Copyright (c) 2016 TripAdvisor
# Licensed under the PostgreSQL License
# https://opensource.org/licenses/postgresql

# Fix working dir
cd $(dirname $0)

if [[ "x" == "x${JAVA_HOME}" ]]; then
  echo "JAVA_HOME not set!"
  echo "The install script will stuff java home into the config for you"
fi

NAME=$(cat settings.gradle | awk '/rootProject.name/ {print $3}' | tr -d "'")

# Gradle install, just builds the dir build/install/pg_global_kv
./gradlew install
rm build/install/${NAME}/bin/${NAME}.bat
sed -i '/DEV_MODE/ s/true/false/' build/install/${NAME}/bin/config.sh
echo "export JAVA_HOME=${JAVA_HOME}" >> build/install/${NAME}/bin/config.sh
sudo rsync -a build/install/${NAME} /opt/

if [ -d /etc/init.d ]; then
  rm -f /etc/init.d/${NAME}
  ln -s /opt/${NAME}/etc/init.d/${NAME} /etc/init.d/${NAME}
fi
