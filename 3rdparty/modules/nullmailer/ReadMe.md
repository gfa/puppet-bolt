Travis Build Status
===================

MASTER: [![Build Status](https://travis-ci.org/dphilpot/dphilpot-nullmailer.svg?branch=master)](https://travis-ci.org/dphilpot/dphilpot-nullmailer)
DEVELOP: [![Build Status](https://travis-ci.org/dphilpot/dphilpot-nullmailer.svg?branch=develop)](https://travis-ci.org/dphilpot/dphilpot-nullmailer)

Puppet module for nullmailer
============================

This Module installs, configures and manages nullmailer.
Multiple remote SMTP server can be handled by nullmailer via IP or Hostname.


Basic usage
-----------

    class {'nullmailer':
      adminaddr      => 'root@example.com',
      defaultdomain  => 'example.com',
      remotes        => ['one.example.com', '127.0.0.2'],
      me             => 'test.domain.example.com',
      package_ensure => 'latest',
      package_name   => 'nullmailer',
    }

Advanced usage
--------------

This module is compatible with The Forman and Hiera:

Hiera example:

In the puppet node-file you need to insert just:

    include nullmailer

In the hiera-file you need to insert something like this:

    nullmailer::adminaddr:      'toor@example.com'
    nullmailer::defaultdomain:  'example.com'
    nullmailer::me:             'test.example.com'
    nullmailer::package_ensure: 'latest'
    nullmailer::package_name:   'nullmailer'
    nullmailer::remotes:
    - one.example.com
    - 127.0.0.2

Notes
-----

Please feel free to create new Issues if you have any problems or make a pull request with new features/bugfixes etc.


Contributors
------------

 * [Dennis Philpot](https://github.com/dphilpot) ([@PhilpotDennis](https://twitter.com/PhilpotDennis))


Copyright and License
---------------------

GNU GENERAL PUBLIC LICENSE Version 2