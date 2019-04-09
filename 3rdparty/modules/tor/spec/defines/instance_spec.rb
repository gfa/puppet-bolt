require 'spec_helper'

describe 'tor::instance' do
  let(:pre_condition) { 'include ::tor' }

  context 'with title `default`' do
    let(:title) { 'default' }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_file('/etc/tor/torrc').with(
        'ensure' => 'file',
        'owner'  => 'tor',
        'group'  => 'tor',
        'mode'   => '0640'
      ).that_requires('File[/etc/tor]')
    end

    it do
      is_expected.to contain_service('tor@default').with(
        'ensure' => 'running',
        'enable' => 'true'
      ).that_requires('File[/etc/tor/torrc]')
    end
  end

  context 'with title `default` and ensure => absent' do
    let(:title) { 'default' }
    let(:params) do
      {
        'ensure' => 'absent'
      }
    end

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_file('/etc/tor/torrc').with(
        'ensure' => 'absent',
        'owner'  => 'tor',
        'group'  => 'tor',
        'mode'   => '0640'
      ).that_requires('File[/etc/tor]')
    end

    it do
      is_expected.to contain_service('tor@default').with(
        'ensure' => 'stopped',
        'enable' => 'false'
      ).that_requires('File[/etc/tor/torrc]')
    end
  end

  context 'with title `test1`' do
    let(:title) { 'test1' }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_file('/etc/tor/instances').with(
        'ensure'  => 'directory',
        'purge'   => 'true',
        'recurse' => 'true',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755'
      )
    end

    it do
      is_expected.to contain_file('/etc/tor/instances/test1').with(
        'ensure'  => 'directory',
        'purge'   => 'true',
        'recurse' => 'true',
        'owner'   => '_tor-test1',
        'group'   => '_tor-test1',
        'mode'    => '0750'
      ).that_requires('File[/etc/tor/instances]')
    end

    it do
      is_expected.to contain_file('/etc/tor/instances/test1/torrc').with(
        'ensure' => 'file',
        'owner'  => '_tor-test1',
        'group'  => '_tor-test1',
        'mode'   => '0640'
      ).that_notifies('Service[tor@test1]').that_requires('File[/etc/tor/instances/test1]')
    end

    it do
      is_expected.to contain_service('tor@test1').with(
        'ensure' => 'running',
        'enable' => 'true'
      ).that_requires('File[/etc/tor/instances/test1/torrc]')
    end
  end

  context 'with title `test2` and ensure => absent' do
    let(:title) { 'test2' }
    let(:params) do
      {
        'ensure' => 'absent'
      }
    end

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_file('/etc/tor/instances').with(
        'ensure'  => 'directory',
        'purge'   => 'true',
        'recurse' => 'true',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755'
      )
    end

    it do
      is_expected.to contain_file('/etc/tor/instances/test2').with(
        'ensure'  => 'absent',
        'purge'   => 'true',
        'recurse' => 'true',
        'owner'   => '_tor-test2',
        'group'   => '_tor-test2',
        'mode'    => '0750'
      ).that_requires('File[/etc/tor/instances]')
    end

    it do
      is_expected.to contain_file('/etc/tor/instances/test2/torrc').with(
        'ensure' => 'absent',
        'owner'  => '_tor-test2',
        'group'  => '_tor-test2',
        'mode'   => '0640'
      ).that_notifies('Service[tor@test2]').that_requires('File[/etc/tor/instances/test2]')
    end

    it do
      is_expected.to contain_service('tor@test2').with(
        'ensure' => 'stopped',
        'enable' => 'false'
      ).that_requires('File[/etc/tor/instances/test2/torrc]')
    end
  end
end
