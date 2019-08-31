# GovCMS Packagist

A packagist resource for Composer projects which contains only the packages
required to build the GovCMS distribution. All the modules available
in this packagist have been reviewed and curated.

## Benefits

1. We (will soon) use this in the GovCMS distribution as a way to ensure that
a SaaS site is a complying SaaS site. It also will allow us to loosen package
versions in the GovCMS distribution in line with Composer best practice.

2. Since Satis does the hard work choose module versions, your `composer update is
much faster.

3. By providing this satis, and a whitelist service, we will enable use to
de-scope modules from the distribution without "hard forking" the projects from
SaaS.

4. By using this as your only packagist source, you can ensure your Drupal
site is compatible with GovCMS, without having to rely on the GovCMS scaffold.
This is useful if you have a soft requirement for a future migration.


## Usage

The de facto usage looks like this in composer.json. If you don't set
`packagist.org` to false then Composer will simply get newer versions
of these modules, making the use of satis redundant. 

```
"repositories": {
    "govcms": {
        "type": "composer",
        "url": "https://satis.govcms.gov.au/"
    },
    "packagist.org": false
},
```

### Whitelist

There is an additional whitelist of modules which are not in the GovCMS
distribution but may be available to some SaaS customers.

```
"govcms-whitelist": {
    "type": "composer",
    "url": "https://satis.govcms.gov.au/whitelist"
},
```

### List of sources

We build additional resources for past versions and some other uses. The key sources are:

* [satis.govcms.gov.au](https://satis.govcms.gov.au) => The latest stable version.
* [/whitelist](https://satis.govcms.gov.au/whitelist) => Additional verified packages.
* [/beta7](https://satis.govcms.gov.au/beta7), [/beta8](https://satis.govcms.gov.au/beta8) => Specific versions.
* [/edge](https://satis.govcms.gov.au/edge) => Latest development version.

## Topics

### Use the latest version of GovCMS

You can use GovCMS distribution with the following in your composer.json.
This requires setting up your settings.php appropriate for your hosting.

```
"repositories": {
    "govcms": {
        "type": "composer",
        "url": "https://satis.govcms.gov.au/"
    },
    "packagist.org": false
},
"require": {
    "govcms/govcms": "~1"
}
```

### Use the GovCMS Drupal settings

By requiring `govcms/scaffold-tooling` in your composer.json the standard
settings for GovCMS, including defaults for hosting on the GovCMS platform,
will be available in `vendor/govcms/scaffold-tooling/drupal`. See
[settings.php](https://github.com/govCMS/govcms8-scaffold-paas/blob/develop/web/sites/default/settings.php)
in the Drupal 8 scaffold for guidance on including these files.

### Use the latest version of GovCMS

You can test the upcoming version of GovCMS by pointing at /edge.
This is something you can do locally, but if you are hosting on
SaaS you won't be able to push these changes.

```
"repositories": {
    "govcms": {
        "type": "composer",
        "url": "https://satis.govcms.gov.au/edge/"
    },
    "packagist.org": false
},
"require": {
    "govcms/govcms": "~1"
}
```

### Use GovCMS distribution, with latest modules from Drupal.org

This is not a service provided by the GovCMS Satis service, as we
only support modules that have been through an internal review. If 
you use these modules, we can't guarantee that there will be an
upgrade path.

You can test upcoming version of modules by manually placing them
in `web/sites/default/modules/`. This location overrides locations like 
`web/modules/`. We welcome these tests, in particular, please let us
know via the issue queue if you encounter any issues.

### Adding modules not in GovCMS

If you are not hosting on the GovCMS platform, or if you are running
PaaS site, you can add additional modules by adding Drupal packagist
in your repositories section:

```
  { "type": "composer", "url": "https://packages.drupal.org/8" },
```

The GovCMS distribution limits module versions, so by doing this, or
adding Composer packagist (by removing `"packagist.org": false`) you should
still get the right modules for GovCMS. Additional modules you add may
have version conflicts with GovCMS but these will become evident when 
you run `composer update`.

## Technical

This project is built on [composer/satis](https://github.com/composer/satis) and
we periodically update the /src from [Satis upstream](http://github.com/composer/satis).

See `ahoy` for build commands. We have commands like `build-edge` for building updated
packagist configuration that lives in /app. There is also `ahoy server` for running
a local server you can use as your repository source for testing.
