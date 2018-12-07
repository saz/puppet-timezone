require 'spec_helper_acceptance'

describe 'timezone class' do

  describe 'running puppet code' do
    it 'works with no errors' do
      pp = <<-PUPPET
        class { '::timezone': timezone => 'Europe/Rome'}
      PUPPET
      # Run it twice and test for idempotency
      apply_manifest( pp, :catch_failures => true)
      apply_manifest( pp, :catch_changes => true)
#          result=on(host,%(ls -la /etc/localtime))
#          expect(result.output).to match(%r(/usr/share))
    end
  end
  describe 'with /etc/localtime an existing file' do
    it 'can update timezone if localtime is not a link' do
      result =  %(unlink /etc/localtime ; touch /etc/localtime)
      check_file = %(ls -la /etc/localtime)
      expect(check_file).to_not match(%r(->))
      px = <<-PUPPET
      class { '::timezone': timezone => 'Europe/Berlin'}
      PUPPET
      # Run it twice and test for idempotency
      apply_manifest( px, :catch_failures => true)
      apply_manifest( px, :catch_changes => true)
    end
  end
end
