# GovCMS Packagist - MAINTENANCE

## What is it

There are four satis servers which are built from four config files (in ./satis-config).
These can be used in the "repositories" section of composer.json.

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
branches of [govcms/govcms8](/hey) (also [scaffold-tooling](/hey) and [require-dev](/hey)).

## Steps to update STABLE

These are the steps to update `STABLE` - which becomes satis.govcms.gov.au once
the code is merged to master on github. Normally you will build all the satis repos
at once (`ahoy build` after updating config files) but this describes in more detail how
to just build `STABLE`.

1. Edit `satis-config/govcms-stable.json`.
  a. remove the blacklist section
  b. remove any packages from the `require` section that aren't `govcms/...`
  c. update the package versions in `require` section

2. Run `ahoy build-stable` to update /app.

3. Run `ahoy verify` to duplicate the tests that run in circle.

4. Run `ahoy dupes` to make sure that no key packages are duplicated. Follow instructions to blacklist packages.

5. Commit all changes including `/app`, which are the hosted files.

6. Make a PR to master on github.com/govcms/satis. Once this is merged it will trigger
quay.io to rebuild the hosted image (see docker-compose.yml).

## Steps to update MASTER and DEVELOP

These steps are similar to `STABLE`, however you don't need to do step 1c because
versions refer to branches.

Run `ahoy build-master` or `ahoy build-develop` to build them into `./app/master` and `./app/develop`

## Steps to update WHITELIST

This is a hassle free one because it doesn't calculate dependencies.

## Troubleshooting maintenance

Building the Satis can result in a building a Satis server that you can't use
to build GovCMS. In a recent example the govcms-stable.json (and others) 
required `"fabpot/goutte": "3.2.3"` in order to ensure this slightly older
version of this project was available to allow govcms to build.

It will happen when trying to build GovCMS from the Satis which can be 
tested with `ahoy verify`.

1. Take a note of the composer error, the packages that it refers to.
2. Build the latest GovCMS somewhere on your file system, and compare the same packages.
3. You should identify a package version that Satis didn't get.
4. And this package explicitly to `config/govcms-*.json` in the `require` section.

## Technical notes

This project is built on [composer/satis](https://github.com/composer/satis) using the
docker container method. The following settings are important because it forces Satis
to resolve an *ideal* set of package versions.

```
    "require-dependencies": true,
    "require-dev-dependencies": true,
    "only-best-candidates": true
```
