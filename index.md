---
layout: default
---
# Loong13 - (Unofficial) Debian Trixie 13 for LoongArch64

Welcome to the Loong13 project! This repository hosts the unofficial[^1] Debian
Trixie 13 distribution rebuilt for the LoongArch64 architecture. The distribution
is built [fully from source](#build-process), without using any binary blobs targeting for
LoongArch64 hardware.

The packages in this archive are built from the official Debian source packages,
with only [minimal modifications](#modified-packages) to ensure build compatibility on LoongArch64 systems.
It is also ensured that upgrading to future Debian official loong64 releases will be as
seamless as possible. The goal of this project is to provide a stable and reliable
Debian experience on LoongArch64 hardware.

The packages are not officially supported by the Debian project, but the usual
procedure for building and uploading Debian packages has been followed as closely as possible.


[^1]: This project is not officially endorsed or supported by the Debian project, although
      the domain name used for hosting this repository is registered under debian.net.

## Downloads

- Installer CD Image (ISO): [debian-13.3.0-loong64-netinst.iso](/debian-loong64-cd/13.3.0/loong64/iso-cd/debian-13.3.0-loong64-netinst.iso)
- Offline DVD Image (ISO): [debian-13.3.0-loong64-DVD-1.iso](/debian-loong64-cd/13.3.0/loong64/iso-dvd/debian-13.3.0-loong64-DVD-1.iso)
- Network Installer Image (ISO): [mini.iso](/debian-loong64/dists/trixie/main/installer-loong64/current/images/netboot/mini.iso)
- More installation images: [debian-loong64-cd/](/debian-loong64-cd/)

## Repositories

- Main APT Repository: <code>deb <a href="/debian-loong64/">{{ '/debian-loong64/' | absolute_url }}</a> trixie main contrib non-free non-free-firmware</code>
- Security Updates: <code>deb <a href="/debian-loong64-security/">{{ '/debian-loong64-security/' | absolute_url }}</a> trixie main contrib non-free non-free-firmware</code>

## Warranty and Support

The packages provided in this repository are distributed "as is", without any
warranty of any kind, either expressed or implied. Use at your own risk.

## Updates and Maintenance

The packages in this repository will be updated following the official Debian
archive updates. When new packages are uploaded to the `proposed-updates` or
`security` repositories of the official Debian archive, they will be automatically
rebuilt for LoongArch64 and made available in this repository after successful
build. Point releases of Debian will also be mirrored here with one or two days
of delay to finish the transition. This [workflow](https://wiki.debian.org/DebianReleases#How_packages_move_between_different_repositories)
is the same as the official Debian repositories.

The maintenance of this repository is done on a best-effort basis and is expected
to be kept up to date with the official Debian releases as much as possible in
a 3-year period following the initial release of Debian Trixie 13 until EOL of
Trixie in mid-2028. Further LTS support is not guaranteed.

## Security updates

Security updates will be provided in a timely manner, following the official
Debian security update releases. However, there would be a delay to finish the
build process for LoongArch64 architecture, since the packages will be built
after the release of the official source packages.

## Acknowledgements

This project would not be possible without the hard work and dedication of the
Debian community. Thanks to all the developers and maintainers who have contributed
to the Debian project over the years. Special thanks to the maintainers of the
LoongArch64 ports. Without their efforts, this project would not have been possible.

It is also important to acknowledge the support from [Apernet](https://apernet.io),
who has sponsored the hosting infrastructure for this repository and provided hosting
for the builder machines.

## Issues and Feedback

If you encounter any issues, please do NOT directly report to the Debian bug tracker.
Instead, if the same issue exists in the official Debian distribution for other architectures,
please report it there. For LoongArch64-specific issues, please open an issue in the
[GitHub Issues](https://github.com/triloong/issues/issues) page of this repository.

## Technical Details

### Build System

The build system for this repository is based on [Debian's own buildd infrastructure](https://wiki.debian.org/buildd).
The packages are built using [sbuild](https://wiki.debian.org/sbuild) in a chroot
environment set up for LoongArch64 architecture. The build process is managed by
[wanna-build](https://wiki.debian.org/DebianWannaBuildInfrastructureOnOneServer), which monitors the official Debian
archive for new source package uploads and triggers the build process accordingly.
It has been [customized](https://github.com/triloong/wanna-build) to fit the needs of this project.

Builders are running on LoongArch64 hardware, using [pybuildd](https://salsa.debian.org/wb-team/pybuildd)
as the build daemon, inside of which sbuild is invoked to build packages. The
scripts and configuration files for the build system are available in [triloong/buildd](https://github.com/triloong/buildd).

### Management of the Repository

The repository is managed using [reprepro](https://wiki.debian.org/DebianRepository/SetupWithReprepro), with
additional [scripts](https://github.com/triloong/repos) to automate the process of handling debian installer images,
generating DEP-11 metadata and generating Acquire-by-Hash indices.

### Build of CD Images

The Debian installer images are built using [debian-cd](https://packages.debian.org/trixie/debian-cd).
The configuration files and scripts used to build the images are available in [triloong/debian-cd](https://github.com/triloong/cd-image).

### Build Process

The build process can be divided into three main phases: bootstrapping, and two rounds of package building.

#### Bootstrapping

As said, no binary blobs targeting LoongArch64 hardware were used in the build process.
Thus, bootstrapping was done using [rebootstrap](https://wiki.debian.org/HelmutGrohne/rebootstrap). The script is [modified](https://github.com/triloong/rebootstrap)
to finally build a special minimal set of packages using cross-compilation from an arm64 host to satisfy the dependencies
for build-essential packages and `debhelper` to start the native build process on LoongArch64 hardware. The packages built
by rebootstrap are available in [rebootstrap/](/rebootstrap/).

#### Native Build Round I

After bootstrapping, all of the packages were built natively on LoongArch64 hardware. To break circular dependencies,
some packages were built using cross-compilation or with special build profiles manually. The manually built packages are
stored in [seeds/](/seeds/). The packages in `rebootstrap/` and `seeds/` were used only to satisfy build dependencies and
were not included in the final repository. The built packages were uploaded to a repository in [builds1/](/builds1/).

#### Native Build Round II

To avoid the influence of the manually built packages in `seeds/` and the packages built by rebootstrap, a second round
of native build was performed. In this round, all packages were built again on LoongArch64 hardware, using only the
packages available in the `builds1/` repository to satisfy build dependencies. The resulting packages were uploaded to
a repository in [builds2/](/builds2/), which forms the final repository for this project.

#### Finalization

After the second round of native build, the repository was finalized by first importing the packages from `builds2/`
into the main repository. Then, all the architecture-independent packages (marked as `all` in Debian) were downloaded
from the official Debian archive and imported into the main repository. This ensures that all packages in the
repository are available for installation on LoongArch64 systems. After that, all the existing packages in proposed-updates
and security repositories were built for LoongArch64 using only the packages in the main repository to satisfy build dependencies.
The resulting packages were then imported into the respective repositories to complete the setup.

### Modified Packages

The following packages have been modified from their original Debian source packages to
ensure build compatibility on LoongArch64 systems.


<style>
    .superseded {
        text-decoration: line-through;
    }
</style>
<table>
  <thead>
    <tr>
      <th>Package</th>
      <th>Version</th>
      <th>Original Version</th>
      <th>Description</th>
      <th>References</th>
      <th>LoongArch64-specific?</th>
    </tr>
  </thead>
  <tbody>
  {% assign mpkgs = site.data.mpkg | where_exp: 'p', 'p.versions == nil' %}
  {% assign vpkgs = site.data.mpkg | where_exp: 'p', 'p.versions' %}
  {% for pkg in vpkgs %}
    {% for ver in pkg.versions %}
      {% assign new_pkg = pkg | merge: ver %}
      {% assign mpkgs = mpkgs | push: new_pkg %}
    {% endfor %}
  {% endfor %}
  {% assign mpkgs = mpkgs | group_by: 'package' | sort: 'name' %}
  {% for pkg_n in mpkgs %}
  {% assign pkg_it = pkg_n.items | sort: 'version' %}
  {% for pkg in pkg_it %}
  <tr class="{% if pkg.superseded %}superseded{% endif %}">
    <td>{{ pkg.package }}</td>
    <td>{{ pkg.version }}</td>
    <td>{{ pkg.oldversion }}</td>
    <td>{{ pkg.description }}</td>
    <td>
        {% if pkg.bugs %}
        {% for bug in pkg.bugs %}
        {% if bug.debian %}
        <a href="https://bugs.debian.org/{{ bug.debian }}">BTS #{{ bug.debian }}</a>
        {% elsif bug.github %}
        <a href="https://github.com/{{ bug.github.repo }}/issues/{{ bug.github.id }}">{{ bug.github.repo }}#{{ bug.github.id }}</a>
        {% elsif bug.url %}
        <a href="{{ bug.url.link }}">{{ bug.url.text }}</a>
        {% endif %}
        {% endfor %}
        {% endif %}
    </td>
    <td>{% if pkg.loongarch_only %}Yes{% else %}No{% endif %}</td>
  </tr>
  {% endfor %}
  {% endfor %}
  </tbody>
</table>
