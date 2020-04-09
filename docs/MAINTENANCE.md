# GovCMS Packagist - MAINTENANCE

## What is it

There are four satis servers which are built from four config files (in ./satis-config).
These can be used in the "repositories" section of composer.json.

|   |   |   |
| --- | --- | --- |
| `STABLE` | govcms-stable.json | https://satis.govcms.gov.au/ |
| `MASTER` | govcms-master.json | https://satis.govcms.gov.au/master |
| `DEVELOP` | govcms-develop.json | https://satis.govcms.gov.au/develop |
| `WHITELIST` | govcms-whitelist.json | https://satis.govcms.gov.au/whitelist |

They are updated by running `ahoy build` which populates the `./app` directory
with static files.

## When to update

Currently, updating is manual. The job to automate it was completed but it got stuck waiting
for deployment tokens. In the meantime it has been found that manual intervention is usually needed.

Updating `STABLE` should be done when there is a new point release of GovCMS.

Updating `MASTER` and `DEVELOP` should be done when the `master` and `develop`
branches are updated on
 * [govcms/govcms8](https://github.com/govCMS/govcms8)
 * [scaffold-tooling](https://github.com/govCMS/scaffold-tooling)
 * [require-dev](https://github.com/govCMS/require-dev)
  
## Update MASTER

This will update the `./app/master` directory.

1. Clean `./satis-config/govcms-master.json` by removing:

    * extra packages from `require` - only leave the first three `govcms/*` packages
    * the `blacklist` section - remove completely

2. Run `ahoy build-master` to update /app.

3. Run `ahoy verify-master` - it will likely fail.

4. Run `ahoy debug-master` - follow instructions.

5. Re-run `ahoy build-master` and `ahoy verify-master` (ie. repeat the above steps as needed).

## Update DEVELOP

This will update the `./app/develop` directory. Repeat the exact steps you followed to
update MASTER, just replace `master` with `develop`.

1. Clean `./satis-config/govcms-develop.json` by removing:

    * extra packages from `require` - only leave the first three `govcms/*` packages
    * the `blacklist` section - remove completely

2. Run `ahoy build-develop` to update /app.

3. Run `ahoy verify-develop` - it will likely fail.

4. Run `ahoy debug-develop` - follow instructions.

5. Re-run `ahoy build-develop` and `ahoy verify-develop` (ie. repeat the above steps as needed).

## Update STABLE

This will update the `./app` directory. You are repeating the steps you followed to
update MASTER, just replace `master` with `stable`.

There is only one extra step (step 2).


1. Clean `./satis-config/govcms-stable.json` by removing:

    * extra packages from `require` - only leave the first three `govcms/*` packages
    * the `blacklist` section - remove completely

2. *ONLY FOR STABLE* update the package versions for the `govcms/*` versions to the latest versions.

3. Run `ahoy build-stable` to update /app.

4. Run `ahoy verify-stable` - it will likely fail.

5. Run `ahoy debug-stable` - follow instructions.

6. Re-run `ahoy build-stable` and `ahoy verify-stable` (ie. repeat the above steps as needed).

## Steps to update WHITELIST

This is a hassle free one because it doesn't calculate dependencies. Run `ahoy build-whitelist`.

## Push

Once you have updated all branches, create a PR to https://github.com/govcms/satis. Once this is merged it will trigger
quay.io to rebuild the an image (see docker-compose.yml).

## Technical notes

This project is built on [composer/satis](https://github.com/composer/satis) using the
docker container method. The following settings are important because it forces Satis
to resolve an *ideal* set of package versions.

```
    "require-dependencies": true,
    "require-dev-dependencies": true,
    "only-best-candidates": true
```
