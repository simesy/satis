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
This is useful if you have a soft requirement for a future migration, but
for now just want to use your own Composer setup, and it will make your
Composer builds **much** faster - a default GovCMS distribution can download
200-300 packages.


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

With this in place, you could emulate the GovCMS distribution
with the following, but check out the composer.json in the
GovCMS scaffold for a more complete picture when it comes to 
running your project on the GovCMS platform.

```
"require": {
    "govcms/govcms": "~1"
}
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

## Tips

* If you need 




## Technical

This project is built on [composer/satis](https://github.com/composer/satis) and
periodically updated the /src from upstream.

Run `ahoy build` to update the packages. GovCMS


### Usage / build

The key commands are found in .ahoy.yml - whether you want to use Ahoy or run
them manually.

The webroot of packagist repo is /app which is generated (and updated) by `ahoy build`.
This is then committed and served statically at https://satis.govcms.gov.au

To use this in your composer, add

```
"repositories": {
    "govcms": {
        "type": "composer",
        "url": "https://satis.govcms.gov.au"
    }
}
```

You can disable the default packagist this also in the respositories section:
```
    "packagist.org": false

```


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

