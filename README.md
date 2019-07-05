# NAMESAREHARD Satis

A Satis implementation which provides a static packagist repo from a list of whitelisted
composer packages. It has a 

## Overview

### About Satis

This project is built on [composer/satis](https://github.com/composer/satis),
and you can read the [original README](https://github.com/composer/satis/blob/master/README.md)
about this product.

Some modifications from the upstream solution should be:

- remove upstream test files and such
- add govcms-package-mirror.json
- add .ahoy.yml
- add .gitignore tweaks, etc
- change Dockerfile is changed for Lagoon

### Usage / build

The key commands are found in .ahoy.yml - whether you want to use Ahoy or run
them manually.

The webroot of packagist repo is /app which is generated (and updated) by `ahoy build`.
This is then committed and served statically at https://satis.govcms.gov.au


### Road map

The goals:
 
- Composer packagist repo which you can point to *exclusively* and build GovCMS
SaaS or PaaS.

- Simple and transparent configuration - demonstrated via the base Satis product.

- Could provide dependency resolution with no internet access (security principle).

- Provide a process for inclusion of new packages through PR and issue template.

- (To be explored) package hashing, warm cache etc.


## Request a new package

All packages and their dependencies defined in govcms are automatically available.

For new package (eg a new Drupal module).

1. create an issue with the "new package" template"
1. Modify the package-mirror.json
1. Create a PR with this modification against the issue

Favourable features

1. Security team coverage
1. Code is maintained
1. Functionality is admin-only
1. Functionility does not alter content model
1. Functionality is unique
1. Demonstrated reduction in theme code

