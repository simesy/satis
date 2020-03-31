#!/usr/bin/env bash
IFS=$'\n\t'
set -euo pipefail

GOVCMS_SCAFFOLD="${GOVCMS_SCAFFOLD:-/tmp/govcms-build}"
SATIS_BUILD="${SATIS_BUILD:-/tmp/satis-build/app}"

rm -Rf "${GOVCMS_SCAFFOLD}"

php -S localhost:4141 -t "${SATIS_BUILD}" > /tmp/phpd.log 2>&1 &
composer create-project --no-install govcms/govcms8-scaffold-paas "${GOVCMS_SCAFFOLD}"
cd "${GOVCMS_SCAFFOLD}"
composer config secure-http false

for branch in {"","develop","master"}; do
    echo -e "\n\n\n--> Test build GovCMS against http://localhost:4141/${branch}\n\n\n"

    # Ensure no conflicts with composer update.
    rm -Rf vendor && rm -Rf web/core && rm -Rf web/modules/contrib/* && rm -Rf web/profiles/* rm composer.lock

    # Replace satis.govcms.gov.au with local build.
    composer config repositories.govcms composer http://localhost:4141/"${branch}"
    composer config repositories

    # Point to the appropriate versions.
    if [ "${branch}" = "master" ] || [ "${branch}" = "develop" ] ; then
        composer require govcms/govcms:1.x govcms/require-dev:dev-"${branch}" govcms/scaffold-tooling:dev-"${branch}"
    fi

    composer -n -vvv update
    composer validate
done
