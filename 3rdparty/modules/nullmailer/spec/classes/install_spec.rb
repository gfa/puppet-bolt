require 'spec_helper'

describe 'nullmailer::install' do
  let :params do
    {
      'package_ensure' => 'installed',
      'package_name'   => 'nullmailer',
    }
  end

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_package('nullmailer').with_name('nullmailer').with_ensure('installed') }
end
