#!/usr/bin/env bash
echo "=========================== Starting Release Script ==========================="
PS4="\[\e[35m\]+ \[\e[m\]"
set -vex
pushd "$(dirname "${BASH_SOURCE[0]}")/../"


if [ -z "${RELEASE_VERSION}" ] || [ -z "${DEVELOPMENT_VERSION}" ]; then
  echo "Please provide a Release and Development version in the format <alfresco-super-pom>-<additional-info> (1.3 or 1.4-SNAPSHOT)"
  exit 1
fi

# Use full history for release
git checkout -B "${BRANCH_NAME}"


mvn -B release:prepare \
  -DreleaseVersion="${RELEASE_VERSION}" \
  -DdevelopmentVersion="${DEVELOPMENT_VERSION}" \
  -Darguments=-DskipTests \
  -DscmCommentPrefix="[maven-release-plugin][skip ci] " \
  -Dusername="${GIT_USERNAME}" \
  -Dpassword="${GIT_PASSWORD}"


mvn deploy -PmavenCentral -Dgpg.passphrase=${GPG_PASSPHRASE}

mvn -B release:perform \
  -DreleaseVersion="${RELEASE_VERSION}" \
  -DdevelopmentVersion="${DEVELOPMENT_VERSION}" \
  -Darguments=-DskipTests \
  -DscmCommentPrefix="[maven-release-plugin][skip ci] " \
  -Dusername="${GIT_USERNAME}" \
  -Dpassword="${GIT_PASSWORD}"


popd
set +vex
echo "=========================== Finishing Release Script =========================="

