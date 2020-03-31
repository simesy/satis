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
branches of [govcms/govcms8](/hey) (also [scaffold-tooling](/hey) and [require-dev](/hey)).

## Steps to update STABLE

These are the steps to update `STABLE` - which becomes satis.govcms.gov.au once
the code is merged to master on github. Normally you will build all the satis repos
at once (`ahoy build` after updating config files) but this describes in more detail how
to just build `STABLE`.

1. Edit `satis-config/govcms-stable.json`.
  a. remove packages in `require` other than 'govcms/govcms', 'govcms/scaffold-tooling', 'govcms/require-dev'.
  b. remove the blacklist section
  c. update the package versions in `require` section to the latest releases

2. Run `ahoy build-stable` to update /app.

3. Run `ahoy verify` which confirms that a govcms project can build on this satis.

4. Run `ahoy check-missing` and `ahoy check-dupes` (see next section).

5. Commit all changes including `/app`, which are the hosted files.

6. Make a PR to master on github.com/govcms/satis. Once this is merged it will trigger
quay.io to rebuild the hosted image (see docker-compose.yml).

## Two things that will go wrong

The Satis strategy is a little different to how Satis is supposed to work because
it tries to resolve only one version of each govcms, Drupal and each Drupal module.

The first problem is duplicate packages - additional versions of project which we
don't want. The script `ahoy check-dupes` will offer some candidates to add to a
`blackist` section of the satis config.

The second problem is missing packages. `ahoy verify` will report problems. The 
script `ahoy check-missing` will analyse a build and suggest additional projects
and versions.

Both these commands should output enough information to resolve any problems. 

## Steps to update MASTER and DEVELOP

These steps are similar to `STABLE`, however you don't need to do step 1.c because
versions refer to branches.

Run `ahoy build-master` or `ahoy build-develop` to build them into `./app/master` and `./app/develop`

## Steps to update WHITELIST

This is a hassle free one because it doesn't calculate dependencies.

## Technical notes

This project is built on [composer/satis](https://github.com/composer/satis) using the
docker container method. The following settings are important because it forces Satis
to resolve an *ideal* set of package versions.

```
    "require-dependencies": true,
    "require-dev-dependencies": true,
    "only-best-candidates": true
```
