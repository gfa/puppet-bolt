require 'spec_helper'

describe 'nullmailer' do
  let :params do
    {
      'remotes' => ['127.0.0.1'],
    }
  end

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('nullmailer::install') }
  it { is_expected.to contain_class('nullmailer::config').that_requires('Class[nullmailer::install]') }
  it { is_expected.to contain_class('nullmailer::service').that_subscribes_to('Class[nullmailer::config]') }
end
