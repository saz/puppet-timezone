shared_examples_for 'validate parameters' do
  [
    'autoupgrade'
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) { { param.to_sym => 'foo' } }
      it { expect { is_expected.to create_class('timezone') }.to raise_error(Puppet::Error, %r{is not a boolean}) }
    end
  end
end
