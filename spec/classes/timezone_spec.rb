require 'spec_helper'

describe 'timezone', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:params) { {} }
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('timezone') }

      case facts[:os]['family']
      when 'Debian'

        context 'when using default class parameters' do
          it { is_expected.to contain_file('/etc/timezone') }
          it { is_expected.to contain_file('/etc/timezone').with_ensure('file') }
          it { is_expected.to contain_file('/etc/timezone').with_content(%r{Etc/UTC}) }
          it { is_expected.to contain_exec('update_timezone').with_command(%r{^dpkg-reconfigure -f noninteractive tzdata$}) }
          it { is_expected.to contain_package('tzdata').with(ensure: 'present', before: 'File[/etc/localtime]') }
          it { is_expected.to contain_file('/etc/localtime').with(ensure: 'link', target: '/usr/share/zoneinfo/Etc/UTC') }
        end

        context 'when timezone => "Europe/Berlin"' do
          let(:params) { { timezone: 'Europe/Berlin' } }

          it { is_expected.to contain_file('/etc/timezone').with_content(%r{^Europe/Berlin$}) }
          it { is_expected.to contain_file('/etc/localtime').with_target('/usr/share/zoneinfo/Europe/Berlin') }
        end

        context 'when autoupgrade => true' do
          let(:params) { { autoupgrade: true } }

          it { is_expected.to contain_package('tzdata').with_ensure('latest') }
        end

        context 'when ensure => absent' do
          let(:params) { { ensure: 'absent' } }

          it { is_expected.to contain_package('tzdata').with_ensure('present') }
          it { is_expected.to contain_file('/etc/timezone').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/localtime').with_ensure('absent') }
        end

      when 'RedHat'
        case facts[:os]['release']['major']
        when '6'
          context 'redhat/centos 6' do
            context 'when using default class parameters' do
              it { is_expected.to contain_package('tzdata').with(ensure: 'present', before: 'File[/etc/localtime]') }

              it { is_expected.to contain_file('/etc/sysconfig/clock').with_ensure('file') }
              it { is_expected.to contain_file('/etc/sysconfig/clock').with_content(%r{^ZONE="Etc/UTC"$}) }
              it { is_expected.not_to contain_exec('update_timezone') }

              it { is_expected.to contain_file('/etc/localtime').with(ensure: 'link', target: '/usr/share/zoneinfo/Etc/UTC') }
            end

            context 'when timezone => "Europe/Berlin"' do
              let(:params) { { timezone: 'Europe/Berlin' } }

              it { is_expected.to contain_file('/etc/sysconfig/clock').with_content(%r{^ZONE="Europe/Berlin"$}) }
              it { is_expected.to contain_file('/etc/localtime').with_target('/usr/share/zoneinfo/Europe/Berlin') }
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
          end
        when '7', '8'
          context 'redhat/centos 7, 8' do
            it { is_expected.not_to contain_file('/etc/sysconfig/clock') }
            it { is_expected.to contain_file('/etc/localtime').with_ensure('link') }
            it { is_expected.to contain_exec('update_timezone').with_command('timedatectl set-timezone Etc/UTC').with_unless('timedatectl status | grep "Timezone:\|Time zone:" | grep -q Etc/UTC') }
          end
        end # end RedHat version
      else
        pending "There are no tests for #{os}"
      end # end OS Family
    end
  end
end
