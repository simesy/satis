#!/usr/bin/env bash
IFS=$'\n\t'
set -euo pipefail

GOVCMS_BUILD="${GOVCMS_BUILD:-/tmp/satis-build-conflict-check}"
rm -Rf "${GOVCMS_BUILD}"

SATIS_BUILD="${SATIS_BUILD:-./app}"
php -S localhost:4142 -t "${SATIS_BUILD}" > /tmp/phpd.log 2>&1 &

# Install raw govcms that points to the latest releases.
composer create-project --no-install govcms/govcms8-scaffold-paas "${GOVCMS_BUILD}"
cd "${GOVCMS_BUILD}"
cp composer.json composer-copy.json && cat composer-copy.json \
  | jq .repositories='{"drupal":{"type":"composer","url": "https://packages.drupal.org/8"},"custom":{"type":"path","url":"custom/composer"},"govcms":{"type":"composer","url":"http://localhost:4142"}}' \
  | tee composer.json > /dev/null
COMPOSER_MEMORY_LIMIT=-1 composer update

# Get a list of desired versions from the world.
target_list=$(composer info --format=json | jq -r '.installed[] | "\(.name) \(.version)"' | sort)

# Point to the local satis build.
composer config secure-http false
cp composer.json composer-copy.json && cat composer-copy.json \
  | jq .repositories='{"govcms":{"type":"composer","url":"http://localhost:4142"},"packagist.org":false}' \
  | tee composer.json > /dev/null

# Remove installed things because they give false positives against the repository search.
rm -Rf vendor web/core web/modules/custom composer.lock

suggestions=""
for target in $target_list
do
    project=$(echo "${target}" | cut -d" " -f1)
    version=$(echo "${target}" | cut -d" " -f2)

    if [ "${project}" != "govcms/custom" ]; then
        match=$(composer show "${project}" --all --format=json 2>/dev/null | jq -r '.versions[] | select(. == "'"${version}"'")')
        if [ "${version}" = "${match}" ]; then
            echo -e "\033[1;32mPackage found:\033[0m ${project}:${version}"
        else
            echo -e "\033[1;91mMissing package:\033[0m ${project}:${version}"
            suggestions="${suggestions}    \"${project}\": \"${version}\",\n"
        fi
    fi
done

if [ ! -z "$suggestions" ]; then
    echo -e "\033[1;35m"
    echo "Additional 'requires' for satis config."
    echo "These items have not resolved properly in the satis build."
    echo "Re-run ahoy build and verify.sh after modifying satis config."
    echo -e "\033[0m"

    echo '"require": {'
    echo -e "${suggestions}"
fi
