require 'spec_helper'
default_content = <<-CONTENT
# managed with puppet (module needrestart)

$nrconf{default_value} = {
};
CONTENT

test_content = <<-CONTENT
# managed with puppet (module needrestart)

$nrconf{default_value} = {
    restart = 'l';
    defno = 0;
    blacklist = [
        qr(^/usr/bin/sudo(\\.dpkg-new)?$),
        qr(^/sbin/(dhclient|dhcpcd5|pump|udhcpc)(\\.dpkg-new)?$)
    ];
};
CONTENT

describe 'needrestart' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'with default values for all parameters' do
          it { is_expected.to contain_class('needrestart') }
          it { is_expected.to contain_class('needrestart::install') }
          it { is_expected.to contain_class('needrestart::config') }
          it { is_expected.to contain_package('needrestart') }
          it {
            is_expected.to contain_file('/etc/needrestart/conf.d/').with(
              'ensure' => 'directory',
            )
          }
          it {
            is_expected.to contain_file('/etc/needrestart/conf.d/overrides.conf').with(
              'content' => default_content,
            )
          }
        end

        context 'with config values' do
          let(:params) do
            {
              'configs' => {
                'restart' => 'l',
                'defno' => 0,
                'blacklist' => [
                  'qr(^/usr/bin/sudo(\.dpkg-new)?$)',
                  'qr(^/sbin/(dhclient|dhcpcd5|pump|udhcpc)(\.dpkg-new)?$)',
                ],
              },
            }
          end

          it { is_expected.to contain_class('needrestart') }
          it {
            is_expected.to contain_file('/etc/needrestart/conf.d/').with(
              'ensure' => 'directory',
            )
          }
          it {
            is_expected.to contain_file('/etc/needrestart/conf.d/overrides.conf').with(
              'content' => test_content,
            )
          }
        end

        context 'with different package name' do
          package_name = 'needrestart_pkg'
          let(:params) { { 'package_name' => package_name } }

          it {
            is_expected.to contain_package('needrestart').with(
              'name' => package_name,
            )
          }
        end

        context 'with package removed' do
          let(:params) { { 'package_ensure' => 'absent' } }

          it {
            is_expected.to contain_package('needrestart').with(
              'ensure' => 'absent',
            )
          }
        end
      end
    end
  end

  context 'unsupported os' do
    let(:facts) do
      {
        operatingsystem: 'UnsupportedOs',
      }
    end

    it { is_expected.to contain_class('needrestart') }
    it { is_expected.not_to contain_class('needrestart::install') }
    it { is_expected.not_to contain_class('needrestart::config') }
  end
end
