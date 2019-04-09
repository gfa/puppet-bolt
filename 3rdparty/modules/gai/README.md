# gai

[![Build Status](https://travis-ci.org/smoeding/puppet-gai.svg?branch=master)](https://travis-ci.org/smoeding/puppet-gai)
[![Puppet Forge](http://img.shields.io/puppetforge/v/stm/gai.svg)](https://forge.puppetlabs.com/stm/gai)
[![License](https://img.shields.io/github/license/smoeding/puppet-gai.svg)](https://raw.githubusercontent.com/smoeding/puppet-gai/master/LICENSE)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with gai](#setup)
    * [What gai affects](#what-gai-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with gai](#beginning-with-gai)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Manage the configuration of the default address selection for IPv6 in `/etc/gai.conf`.

## Module description

RFC 3484 provides an algorithm to sort the result of a call to `getaddrinfo(3)` when multiple answers are returned. Especially for hosts connected to an IPv4 and an IPv6 network it might be necessary to modify these static rules. For Linux using the glibc implementation this can be done with the `/etc/gai.conf` configuration file. This module provides a way to manage this file in your environment.

## Setup

### What gai affects

The module creates and modifies the `/etc/gai.conf` file. The settings in this file can affect the order in which network addresses are used when connecting to a remote host. See [RFC 3484](https://www.ietf.org/rfc/rfc3484.txt) for details.

### Setup requirements

The gai module requires the Puppetlabs modules `stdlib`.

### Beginning with gai

Declare the gai class to install an configuration file containing comments only. In this case the operating system enforces the default rules. [RFC 3484](https://www.ietf.org/rfc/rfc3484.txt) has the details.

```puppet
class { 'gai': }
```

## Usage

### Modify the precedence rules to prefer IPv4 addresses

The class parameter `precedence` takes a hash where the keys are netmasks and the associated values define the order in which these netmasks are checked. The following example shows a setup where IPv4 addresses are prefered when the destination host also has an IPv6 address.

```puppet
class { 'gai':
  precedence => {
    '::/96'         => '20',
    '2002::/16'     => '30',
    '::/0'          => '40',
    '::1/128'       => '50',
    '::ffff:0:0/96' => '100',
  }
}
```

There is also a builtin class that can be used as a shortcut for this configuration.

```puppet
class { 'gai::preferipv4': }
```

## Reference

### Classes

#### Public Classes

* `gai`: The main class which installs the `/etc/gai.conf` file.

* `gai::preferipv4`: Installs a predefined set of preference rules that cause the system to prefer IPv4 addresses.

#### Class: `gai`

The main class to manage the `/etc/gai.conf` file.

##### Parameters (all optional)

* `label`: A hash with netmask/precedence pairs for the label table. The precedence value should be an integer. It is used to define the order of evaluation.

* `precedence`: A hash with netmask/precedence pairs for the precedence table. Again the precedence value should be an integer defining the order of evaluation.

* `scopev4`: A hash with mask/value pairs for the scope table. Entries are added to the RFC 3484 scope table.

* `reload`: Indicate if the config should be reloaded for every loopkup. Valid options: 'yes', 'no' or undefined (which doesn't set any value in the file). Default: undef

#### Class: `gai::preferipv4`

The class can be used as a shortcut to install a configuration where IPv4 addresses are prefered over IPv6 addresses.

## Limitations

This module is only useful on systems using glibc and the `/etc/gai.conf` file. It is therefore probably limited to Linux only.

## Development

Feel free to send pull requests for new features. Documentation updates with real world configurations are especially appreciated.
