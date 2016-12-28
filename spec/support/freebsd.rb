shared_examples 'FreeBSD' do
  let(:facts) { { osfamily: 'FreeBSD' } }

  describe 'when using default class parameters' do
    let(:params) { {} }

    it { is_expected.to create_class('timezone') }
    it { is_expected.to contain_class('timezone::params') }

    it do
      is_expected.to contain_file('/etc/localtime').with(ensure: 'file',
                                                         source: 'file:///usr/share/zoneinfo/Etc/UTC')
    end

    context 'when timezone => "Europe/Berlin"' do
      let(:params) { { timezone: 'Europe/Berlin' } }

      it { is_expected.to contain_file('/etc/localtime').with_source('file:///usr/share/zoneinfo/Europe/Berlin') }
    end

    context 'when ensure => absent' do
      let(:params) { { ensure: 'absent' } }
      it { is_expected.to contain_file('/etc/localtime').with_ensure('absent') }
    end

    include_examples 'validate parameters'
  end
end
