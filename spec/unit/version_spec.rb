require 'spec_helper'
require 'herdsman/version'

describe 'Herdsman::VERSION' do
  it 'returns a semver version string' do
    SEMVER_REGEX = /\d+\.\d+\.\d+/

    expect(Herdsman::VERSION).to match(SEMVER_REGEX)
  end
end
