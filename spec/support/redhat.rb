shared_examples 'RedHat' do
  let(:facts) { { osfamily: 'RedHat', operatingsystemmajrelease: '6' } }

  describe 'when using default class parameters' do
    let(:params) { {} }

    it { is_expected.to create_class('timezone') }
    it { is_expected.to contain_class('timezone::params') }

    it do
      is_expected.to contain_package('tzdata').with(ensure: 'present',
                                                    before: 'File[/etc/localtime]')
    end

    context 'when autoupgrade => true' do
      let(:params) { { autoupgrade: true } }
      it { is_expected.to contain_package('tzdata').with_ensure('latest') }
    end

    context 'when ensure => absent' do
      let(:params) { { ensure: 'absent' } }
      it { is_expected.to contain_package('tzdata').with_ensure('present') }
      it { is_expected.to contain_file('/etc/sysconfig/clock').with_ensure('absent') }
      it { is_expected.to contain_file('/etc/localtime').with_ensure('absent') }
    end

    include_examples 'validate parameters'
  end

  context 'when RHEL 6' do
    let(:facts) { { osfamily: 'RedHat', operatingsystemmajrelease: '6' } }
    it { is_expected.to contain_file('/etc/sysconfig/clock').with_ensure('file') }
    it { is_expected.to contain_file('/etc/sysconfig/clock').with_content(%r{^ZONE="Etc\/UTC"$}) }
    it { is_expected.to contain_exec('update_timezone').with_command('tzdata-update') }

    it do
      is_expected.to contain_file('/etc/localtime').with(ensure: 'file',
                                                         source: 'file:///usr/share/zoneinfo/Etc/UTC')
    end

    context 'when timezone => "Europe/Berlin"' do
      let(:params) { { timezone: 'Europe/Berlin' } }

      it { is_expected.to contain_file('/etc/sysconfig/clock').with_content(%r{^ZONE="Europe\/Berlin"$}) }
      it { is_expected.to contain_file('/etc/localtime').with_source('file:///usr/share/zoneinfo/Europe/Berlin') }
    end
  end

  context 'when RHEL 7' do
    let(:facts) { { osfamily: 'RedHat', operatingsystemmajrelease: '7' } }
    it { is_expected.not_to contain_file('/etc/sysconfig/clock').with_ensure('file') }
    it { is_expected.to contain_exec('update_timezone').with_command('timedatectl set-timezone  Etc/UTC') }
    it { is_expected.to contain_file('/etc/localtime').with_target('/usr/share/zoneinfo/Etc/UTC') }

    context 'when timezone => "Europe/Berlin"' do
      let(:params) { { timezone: 'Europe/Berlin' } }

      it { is_expected.to contain_exec('update_timezone').with_command('timedatectl set-timezone  Europe/Berlin') }
      it { is_expected.to contain_file('/etc/localtime').with_target('/usr/share/zoneinfo/Europe/Berlin') }
    end
  end
end
