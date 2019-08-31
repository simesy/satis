# GovCMS Packagist

A packagist resource for Composer projects which contains only the packages
required to build the GovCMS distribution. All the modules available
in this packagist have been reviewed and curated.

## Benefits

1. The limited use of this packagist ensures that a project is GovCMS platform
compliant - particularly SaaS projects.

2. Since Satis does the hard work of resolving module versions, your `composer update`
runs significantly faster.

3. By providing this packagist source, including an additional whitelist, we 
can start reducing the (significant) size of the GovCMS distribution.

4. By using this as your only packagist source, you can ensure your Drupal
site is compatible with GovCMS, without having to rely on the GovCMS scaffold.
This is useful if you have a soft requirement for a future migration.

5. Other (government) organisations can leverage this packagist as a simple
way to limit modules on their own projects.

## Usage

The de facto usage looks like this in composer.json. There is no requirement
to add additional sources.

```
"repositories": {
    "govcms": {
        "type": "composer",
        "url": "https://satis.govcms.gov.au/"
    },
    "packagist.org": false <--- Required in SaaS.
},
"require": {
    "govcms/govcms": "~1"
}

```

### Whitelist

There is an additional whitelist of modules which are not in the GovCMS
distribution but may be available to some SaaS customers. An example would
be sites that temporarily require migrations modules.

```
"govcms-whitelist": {
    "type": "composer",
    "url": "https://satis.govcms.gov.au/whitelist/"
},
```

### List of sources

We build additional resources for past versions and some other uses. The key sources are:

* [satis.govcms.gov.au](https://satis.govcms.gov.au) => The latest stable version.
* [/whitelist](https://satis.govcms.gov.au/whitelist) => Additional verified packages.
* [/beta7](https://satis.govcms.gov.au/beta7), [/beta8](https://satis.govcms.gov.au/beta8) => Specific versions.
* [/edge](https://satis.govcms.gov.au/edge) => Latest development version.

## How to ...

### ... use the latest release of GovCMS

If you are not hosting on the GovCMS platform you can still use the GovCMS
distribution by adding the following in your composer.json. This also requires setting
up your settings.php appropriate for your hosting.

```
"repositories": {
    "govcms": {
        "type": "composer",
        "url": "https://satis.govcms.gov.au/"
    }
},
"require": {
    "govcms/govcms": "~1"
}
```

### ... leverage the GovCMS Drupal settings

By requiring `govcms/scaffold-tooling` in your composer.json you can 
access GovCMS standard Drupal settings. The settings are available in
`vendor/govcms/scaffold-tooling/drupal` after running composer update.

See [settings.php](https://github.com/govCMS/govcms8-scaffold-paas/blob/develop/web/sites/default/settings.php)
in the Drupal 8 scaffold for guidance on using these files.

### ... use the latest version of GovCMS

You can test the upcoming version of GovCMS by pointing at /edge.
SaaS customers can only do this locally, as they won't be able to
deploy these changes.

```
"repositories": {
    "govcms": {
        "type": "composer",
        "url": "https://satis.govcms.gov.au/edge/"
    }
},
"require": {
    "govcms/govcms": "~1"
}
```

### ... use GovCMS distribution, with latest modules from Drupal.org

There are a number of modules in GovCMS which at not the latest
versions available. So is there a way to use the latest versions?

This is not a service provided by the GovCMS Satis/Packagist service. We
only support modules that have been through an internal review. If 
you use upgraded modules, we can't guarantee that there will be an
upgrade path.

Ask yourself why you need these updated modules. Is there a bug you
could patch instead? Can you wait for GovCMS to update?

If you are on PaaS, you can use an upcoming version of any module by manually
placing the whole module in `web/sites/default/modules/`. This location
overrides locations like `web/modules/contrib`. This is not best practice
Drupal/Composer, but if this method helps PaaS customers remain close to a
"vanilla SaaS GovCMS" then it may be a valuable technique to add one or two modules.

You can use the same method locally to test new module versions. We welcome
these tests so please let us know via the issue queue if you
encounter any issues.

### ... add modules not in GovCMS

If you are not hosting on the GovCMS platform, or if you are running
a PaaS site, you can add additional modules by adding Drupal packagist
in your repositories section, assuming they don't have version conflicts
with GovCMS.

```
"repositories": {
    "govcms": {
        "type": "composer",
        "url": "https://satis.govcms.gov.au/"
    }
    "drupal ": {
        "type": "composer",
        "url": "https://packages.drupal.org/8"
    }
},
"require": {
    "govcms/govcms": "~1",
    "drupal/some-other-module": "~2"
}
```

You may also need to remove`"packagist.org": false`) to get depenencies
of your added module. Any version conflicts with GovCMS will become evident when 
you run `composer update`.

## Technical

This project is built on [composer/satis](https://github.com/composer/satis) and
we periodically update the /src from [Satis upstream](http://github.com/composer/satis).

See `ahoy` for build commands. We have commands like `build-edge` for building updated
packagist configuration that lives in /app. There is also `ahoy server` for running
a local server you can use as your repository source for testing.
