require 'spec_helper'

describe 'nullmailer::config' do
  context 'with inherited parameters' do
    let :pre_condition do
      'class { "nullmailer":
        remotes       => ["127.0.0.1"],
        defaultdomain => "localhost",
      }'
    end

    it { is_expected.to compile.with_all_deps }
    it do
      is_expected.to contain_class('nullmailer::config')
        .with_adminaddr('')
        .with_defaultdomain('localhost')
        .with_remotes(['127.0.0.1'])
        .with_me(nil)
    end
    it { is_expected.to contain_file('/etc/nullmailer/me').with_ensure('absent') }
  end

  context 'minimal parameters' do
    let :params do
      {
        'adminaddr'     => '',
        'defaultdomain' => 'localhost',
        'remotes'       => ['127.0.0.1'],
        'me'            => '',
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/nullmailer').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/nullmailer/me').with_ensure('absent') }

    {
      '/etc/nullmailer/adminaddr' => "\n",
      '/etc/nullmailer/defaultdomain' => "localhost\n",
      '/etc/nullmailer/remotes' => "127.0.0.1\n",
      '/etc/mailname' => "localhost\n",
    }.each do |filename, content|
      it do
        is_expected.to contain_file(filename)
          .with_ensure('file')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(content)
      end
    end
  end

  context 'with full parameter' do
    let :params do
      {
        'adminaddr'     => 'admin@localhost',
        'defaultdomain' => 'localhost',
        'remotes'       => ['127.0.0.1'],
        'me'            => 'root@localhost',
      }
    end

    it { is_expected.to contain_file('/etc/nullmailer/adminaddr').with_content("admin@localhost\n") }

    it do
      is_expected.to contain_file('/etc/nullmailer/me')
        .with_ensure('file')
        .with_owner('root')
        .with_group('root')
        .with_mode('0644')
        .with_content("root@localhost\n")
    end
  end
end
