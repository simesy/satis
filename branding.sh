#!/usr/bin/env bash

##
# Very light touch branding.

sed -i "s/<title/<link rel=\"shortcut icon\" type=\"image\/png\" href=\"\/favicon.png\" \/><title/" "$1"
sed -i "s/Last updated/<img width=\"135\" height=\"74\" style=\"padding-bottom: 1em;\" src=\"\/logo.svg\" \/><br \/>Last updated/" "$1"

sed -i "s/007bff/19305a/g" "$1"
sed -i "s/0056b3/337ab7/g" "$1"
