require 'spec_helper'

describe 'nullmailer::service' do
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_service('nullmailer').with_ensure('running').with_enable(true) }
end
