# frozen_string_literal: true

forge 'http://forge.puppetlabs.com'

mod 'puppetlabs/stdlib', '5.2.0'
mod 'thias/sysctl', '1.0.6'
mod 'puppet-unattended_upgrades',
    git: 'https://github.com/deubert-it/puppet-unattended_upgrades.git',
    ref: 'master'
mod 'puppetlabs-apt', '7.1.0'
mod 'puppetlabs-mysql', '6.2.0'
mod 'puppet/archive', '3.2.1'
mod 'puppetlabs/translate', '1.2.0'
mod 'alexharvey-firewall_multi', '1.12.0'
mod 'puppetlabs-firewall', '1.15.1'
mod 'saz-dnsmasq', '1.4.0'
mod 'LeLutin-fail2ban',
    git: 'https://github.com/lelutin/puppet-fail2ban.git',
    ref: 'master'
mod 'hetzner-needrestart', '1.0.3'
mod 'ssm-munin', '0.2.0'
mod 'stm-debconf', '2.3.0'
mod 'saz-ssh', '5.0.0'
mod 'puppetlabs-concat', '6.1.0'
mod 'dphilpot-nullmailer', '0.0.4'
mod 'stm-gai', '1.2.0'
mod 'thias-root', '1.0.1'
mod 'puppetlabs-inifile', '3.0.0'
mod 'arcaik-tor',
    git: 'https://github.com/gfa/puppet-tor.git',
    ref: 'master'
mod 'puppet-alternatives', '3.0.0'
mod 'puppet-nginx',
    git: 'https://github.com/voxpupuli/puppet-nginx.git',
    ref: 'v1.0.0'
mod 'puppet-systemd',
    git: 'https://github.com/camptocamp/puppet-systemd.git',
    ref: 'master'
mod 'edestecd-clamav', '1.0.0'
mod 'oxc-dovecot', '2.1.0'
mod 'mayflower-prosody',
    git: 'https://github.com/gfa/puppet-prosody.git',
    ref: 'fixes'
mod 'puppet-posix_acl', '0.1.1'
mod 'transmission',
    git: 'https://github.com/craigwatson/puppet-transmission.git',
    ref: 'master'
mod 'thrnio-ip', '1.0.1'

# end of local modules

# modules required by bolt

# https://github.com/puppetlabs/bolt/blob/master/Puppetfile

# Core modules used by 'apply'
mod 'puppetlabs-service', '1.1.0'
mod 'puppetlabs-facts', '0.6.0'
mod 'puppetlabs-puppet_agent', '2.2.2'

# Core types and providers for Puppet 6
mod 'puppetlabs-augeas_core', '1.0.5'
mod 'puppetlabs-host_core', '1.0.3'
mod 'puppetlabs-scheduled_task', '2.0.0'
mod 'puppetlabs-sshkeys_core', '1.0.3'
mod 'puppetlabs-zfs_core', '1.0.4'
mod 'puppetlabs-cron_core', '1.0.3'
mod 'puppetlabs-mount_core', '1.0.4'
mod 'puppetlabs-selinux_core', '1.0.4'
mod 'puppetlabs-yumrepo_core', '1.0.4'
mod 'puppetlabs-zone_core', '1.0.3'

# Useful additional modules
mod 'puppetlabs-package', '0.7.0'
mod 'puppetlabs-puppet_conf', '0.4.0'
mod 'puppetlabs-python_task_helper', '0.3.0'
mod 'puppetlabs-reboot', '2.2.0'
mod 'puppetlabs-ruby_task_helper', '0.4.0'
mod 'puppetlabs-ruby_plugin_helper', '0.1.0'

# Plugin modules
mod 'puppetlabs-azure_inventory', '0.2.0'
mod 'puppetlabs-terraform', '0.3.0'
mod 'puppetlabs-vault', '0.2.2'
mod 'puppetlabs-aws_inventory', '0.3.0'
mod 'puppetlabs-yaml', '0.1.0'

# If we don't list these modules explicitly, r10k will purge them
mod 'canary', local: true
mod 'aggregate', local: true
mod 'puppetdb_fact', local: true
