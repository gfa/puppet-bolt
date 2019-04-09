require 'spec_helper'

describe 'tor' do
  context 'with defaults for all parameters' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('tor') }
    it { is_expected.to contain_class('tor::params') }
    it { is_expected.to contain_class('tor::install') }
    it { is_expected.to contain_class('tor::config') }

    it { is_expected.to contain_package('tor').with('ensure' => 'present') }

    it do
      is_expected.to contain_file('/etc/tor').with(
        'ensure'  => 'directory',
        'purge'   => 'true',
        'recurse' => 'true',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755'
      )
    end
  end

  context 'with defined instances' do
    let(:params) do
      {
        'instances' => {
          'test1' => {
            'settings' => {
              'Nickname' => 'test1',
              'OrPort'   => '9050',
              'DirPort'  => '9030'
            }
          },
          'test2' => {
            'ensure' => 'absent'
          }
        }
      }
    end

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('tor') }
    it { is_expected.to contain_class('tor::params') }
    it { is_expected.to contain_class('tor::install') }
    it { is_expected.to contain_class('tor::config') }

    it { is_expected.to contain_package('tor').with('ensure' => 'present') }

    it do
      is_expected.to contain_file('/etc/tor').with(
        'ensure'  => 'directory',
        'purge'   => 'true',
        'recurse' => 'true',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755'
      ).that_requires('Package[tor]')
    end

    it do
      is_expected.to contain_tor__instance('test1').with('ensure' => 'present')
    end

    it do
      is_expected.to contain_tor__instance('test2').with('ensure' => 'absent')
    end
  end
end
