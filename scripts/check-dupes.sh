#!/usr/bin/env bash

SATIS_BUILD="${SATIS_BUILD:-/tmp/satis-build/app}"

# First argument can be "master" or "develop"
if [ ! -n "${1+set}" ] ; then
    dir="app"
    config="govcms-stable.json"
else
    dir="${SATIS_BUILD}/${1}"
    config="govcms-${1}.json"
fi

for file in "${dir}"/include/*.json
do
    # Get a list of projects that returned multiple packages.
    problems=$(cat "${file}" | jq -r '.packages | [.[] ] | .[] | [.[]] | .[] | .name' | sort | uniq -c | awk '{if($1>1)print$2}')

    if [ -n "$problems" ]; then
        echo -e "\033[1;35m"
        echo "Template blacklist for ${config}"
        echo "You need to remove the lines that the govcms distribution needs."
        echo "(Usually blacklist the newer version, but you have to eye ball each one.)"
        echo "Then update the ${config} config file."
        echo "Re-run ahoy build and verify.sh after modifying satis config."
        echo -e "\033[0m"

        echo '"blacklist": {'
        for project in $problems
        do
            cat $file | jq -r '.packages | .["'"${project}"'"] | to_entries[] | "    \"\(.value.name)\": \"\(.key)\","'
        done
        echo '}'
    fi

done
