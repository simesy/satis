# NAMESAREHARD Satis

A Satis implementation which provides a static packagist repo from a list of whitelisted
composer packages.

## Overview

### About Satis

This project is built on [composer/satis](https://github.com/composer/satis),
and you can read the [original README](https://github.com/composer/satis/blob/master/README.md)
about this product.

The only modifications from the upstream solution should be:

- govcms-package-mirror.json
- .ahoy.yml
- .gitignore tweaks, etc

### Usage / build

The key commands are found in .ahoy.yml - whether you want to use Ahoy or run them manually.

1. The webroot of packagist repo is /build. We commit the build directory 

### Strategy

The goals:
 
- Composer packagist repo which you can point to *exclusively* and build GovCMS
SaaS or PaaS.

- Simple and transparent configuration - demonstrated via the base Satis product.

- Could provide dependency resolution with no internet access (security principle).

- Process for inclusion of new packages through PR and issue template.

- (Medium term big picture goals) package hashing, warm cache etc.


## Request a new package

All packages and their dependencies defined in govcms are automatically available.

For new package (eg a new Drupal module).

1. create an issue with the "new package" template"
1. Modify the package-mirror.json
1. Create a PR with this modification against the issue
1. 

