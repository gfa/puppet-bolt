# needrestart puppet module

### Table of Contents

1. [Description](#description)
1. [Setup](#setup)
   * [What needrestart affects](#what-needrestart-affects)
1. [Usage](#usage)
1. [Parameters](#parameters)
1. [Limitations](#limitations)


## Description
Restarts needed services automatically.
Installs package, configures mode (list, automatic, interactive), facilitates overriding default configuration settings.


## Setup

### What needrestart affects
Once installed, needrestart hooks into package management and init systems. For example, upgrading openssl via apt will restart exim and apache if they have proper init scripts.


## Usage
By default, calling the init class will install the relevant package using the default configuration options.
Overriding configuration is done via hieradata by mapping the relevant config keys as follows:
```
---
needrestart::configs:
  ui_mode: 'a'
  restart: 'l'
  kernelhints: '0'
  defno: 0
  blacklist:
    - 'qr(^/usr/bin/sudo(\.dpkg-new)?$)'
    - 'qr(^/sbin/(dhclient|dhcpcd5|pump|udhcpc)(\.dpkg-new)?$)'
  blacklist_mappings:
    - 'qr(^/tmp/jffi)'
  override_rc:
    'qr(^dbus)': 0
    'qr(^gdm)': 0
    'qr(^mysql)': 0
    'qr(^apache2)': 0
```

## Parameters
### package_ensure
String for ensure parameter to the needrestart package. Default value is "__installed__".

### package_name
String to specify the package name. Default value is "__needrestart__".

## Limitations
Only tested on Debian 7.0,8.0,9.0 and Ubuntu >= 14.04

## Testing
Ensure you are using ruby >= 2.0.0
`bundle`
`bundle exec rake test`

