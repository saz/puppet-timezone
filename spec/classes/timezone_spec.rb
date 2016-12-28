require 'spec_helper'

describe 'timezone' do
  %w(Debian RedHat Gentoo FreeBSD).each do |osfamily|
    describe "on supported osfamily: #{osfamily}" do
      include_examples osfamily
    end
  end
end
