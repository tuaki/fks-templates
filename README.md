# fks-templates

Templates for TeX scaffolding for physics (contest) typesetting.

* TODO installation (Linux distros, windows)
* TODO maintenance (branching, packaging)


## Packaging

Packages for Linux distributions are built in [Open Build Service](http://build.opensuse.org/).
All data are stored in the main Git repository and build service package
contains just a `_service` file that references the Git repository and
transformations to comply with OBS package format.

To rebuild packages with a fresh pull from the repo call

    osc service remoterun

### Debian

  * Beware that Build-Depends is duplicated both in `*.dsc` and
    `debian.control` file (does not need frequent changes though).
