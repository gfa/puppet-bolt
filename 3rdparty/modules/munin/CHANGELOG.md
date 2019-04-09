# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2019-03-03
### Added
- Support for DragonFly BSD ([#46](https://github.com/ssm/ssm-munin/issues/46))
- Support for FreeBSD as master ([#46](https://github.com/ssm/ssm-munin/issues/46))
- Export additional nodes with `munin::node::export::node_definitions`
  if `munin::node::export_node` is enabled.
  ([#44](https://github.com/ssm/ssm-munin/issues/44))
- New parameter `munin::master::package_name`
- New parameter `munin::master::file_group`
- New parameter `munin::master::config_root`

### Changed
- Support puppet 4 and newer. ([#49](https://github.com/ssm/ssm-munin/issues/49))
- Scaffolding updated with PDK 1.9.0

### Fixed
- Support for Arch Linux ([#53](https://github.com/ssm/ssm-munin/issues/53))
- Fixed bug with parameter `munin::master::node_definitions`

### Deprecated
- Module is no longer tested with Puppet 3.x and 2.x
- Module is no longer tested on Ruby < 2.1.9

## [0.1.0] - 2015-12-12

* Added support for Archlinux
  ([#40](https://github.com/ssm/ssm-munin/issues/40))
* Added acceptance tests
* Added CONTRIBUTING.md for how to contribute to the module
  ([#41](https://github.com/ssm/ssm-munin/issues/41))
* Document all parameters in README.md

### munin::node

* Two new parameters: **bind\_address** and **bind\_port**
  ([#37](https://github.com/ssm/ssm-munin/pull/37))
* Bugfix: Rescue InvalidAddressError only if ruby is capable
  ([#38](https://github.com/ssm/ssm-munin/pull/38))

### contributors

Contributors to this release: David Hayes, Julien Pivotto, Stig
Sandbeck Mathisen, Victor Engmark

## [0.0.10] - 2015-08-01

* Bugfix: Add missing dependency for the "munin-node" package when
  $munin::node::purge_configs is true.
  ([#34](https://github.com/ssm/ssm-munin/pull/34))

Contributors to this release: Martin Meinhold

## [0.0.9] - 2015-07-29

* Bugfix: The mastergroup, if used in the node's FQN (Fully Qualified
  Name), should no longer be empty on Puppet 4.0.
  ([#27](https://github.com/ssm/ssm-munin/pull/27))

* Bugfix: Using munin::master and munin::node with export and collect
  disabled should no longer trigger warnings about missing
  storeconfigs.  ([#30](https://github.com/ssm/ssm-munin/issues/30),
  [#33](https://github.com/ssm/ssm-munin/pull/33))

### munin::master

* Add FreeBSD support.

### munin::node

* New feature: Log to syslog with the "log\_destination" and
  "syslog\_facility" parameters.
  ([#23](https://github.com/ssm/ssm-munin/issues/23),
  [#24](https://github.com/ssm/ssm-munin/pull/24),
  [#25](https://github.com/ssm/ssm-munin/pull/25))

* New feature: Set the plugin runtime timeout with the "timeout"
  parameter.  ([#29](https://github.com/ssm/ssm-munin/issues/29),
  [#32](https://github.com/ssm/ssm-munin/pull/32))

* New feature: Purge unmanaged plugins and plugin configuration with
  the "purge_configs" parameter.
  ([#28](https://github.com/ssm/ssm-munin/issues/28),
  [#31](https://github.com/ssm/ssm-munin/pull/31))

## [0.0.8] - 2015-02-06

Support the future parser.

Contributors to this release: Rike-Benjamin Schuppner, Stig Sandbeck
Mathisen

## [0.0.7] - 2014-12-05

This release adds support for DragonFly BSD, FreeBSD, OpenBSD.

Other changes listed below, per component.

Contributors to this release: Alex Hornung, Chris Roddy, Frank
Groeneveld, Fredrik Thulin, Julien Pivotto, Martin Jackson, Sebastian
Wiesinger, Stig Sandbeck Mathisen

### munin::node

* Add "host_name" parameter to override the host name of the munin
  node.

* Add "file_group" parameter, used for configuration and log files.

* Add "log_dir" parameter.

* Improved handling of "allow" ACL parameter.

### munin::master

* Improved collection logic. Set "collect_nodes" to "mine" to collect
  nodes which are targeted for this master, or "unclaimed" to pick up
  nodes not aimed a specific master.

* Add global tls_* parameters for connecting to nodes.

* Add "dbdir", "htmldir", "rundir" parameters.

* Add "extra_config" parameter, which takes an array of extra
  configuration lines for munin.conf.

### munin::plugin

* Support absolute paths as target for a plugin.

## [0.0.6] - 2014-12-05

* Retracted, had a breaking bug on older (3.4.x) puppet versions.

## [0.0.5] - 2014-03-19

* Support multiple masters with different nodes
  (Thanks: Cristian Gae)

* Support older (1.4.6) munin versions
  (Thanks: Sergio Oliveira)

* Update for compatibility with puppet 3.4
  (Thanks: Harald Skoglund)

* Easier configuration with more parameters. All parameters have
  trivial validation.

### munin::master

- new parameter "config_root". Defaults should match supported
  operating systems.

### munin::plugin

- new parameter "config_root". Defaults should match supported
  operating systems.

### munin::node

- new parameter "address". Default is $::fqdn. This will be used as
  the "address" when registering with the munin master.

- new parameter "config_root". Defaults should match supported
  operating systems.

- new parameter "package_name".  Default should match supported
  operating systems.

- new parameter "service_name".  Default should match supported
  operating systems.

- new parameter "service_ensure". Default is "". Possible values: "",
  "running" or "stopped".

### munin::params

- new class

## [0.0.4] - 2013-08-13

Bugfix for the munin::plugin define.

- Bugfix: Ensure that we can run tests on ruby 1.8.

- Bugfix: No longer requires the class `Munin::Plugins`, which does
  not exist in this module.
  ([#3](https://github.com/ssm/ssm-munin/issues/3))

- The `ensure` attribute no longer defaults to "link". If not set, a
  potentially existing plugin with the same name is not touched.

- Plugin and configuration directories are now configurable.

- Improved rspec tests, which now actually match the documentation.

## [0.0.2] - 2013-06-31

A few pull requests

- Bugfix: Install munin package before creating munin-conf.d directory
  ([#1](https://github.com/ssm/ssm-munin/pull/1))

- Make graph strategy configurable
  ([#2](https://github.com/ssm/ssm-munin/pull/2))

- Improve documentation

## [0.0.1] - 2013-06-02

Initial release
