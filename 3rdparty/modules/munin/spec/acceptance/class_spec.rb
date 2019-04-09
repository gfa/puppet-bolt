require 'spec_helper_acceptance'

describe 'munin and munin-node' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-PUPPET_CODE
      class { 'munin::master': }
      class { 'munin::node': }
      PUPPET_CODE

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('munin') do
      it { is_expected.to be_installed }
    end

    describe package('munin-node') do
      it { is_expected.to be_installed }
    end

    describe service('munin-node') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
