require 'spec_helper'
require 'herdsman'

describe Herdsman::Herd do
  describe '#members' do
    it 'returns an enumerable of Herdsman::HerdMember objects' do
      config_double = double(repos: [double(path: '/tmp/foo', revision: 'foo'),
                                     double(path: '/tmp/bar', revision: 'bar')])
      members_double = [double, double]
      herd = described_class.new(env_double, config_double, members_double)

      expect(herd.members).to eq members_double
    end
  end

  describe '#gathered?' do
    it 'returns true when all herd members are gathered' do
      config_double = double(repos: [double(path: '/tmp/foo', revision: 'foo'),
                                     double(path: '/tmp/bar', revision: 'bar')])
      members_double = [double(gathered?: true), double(gathered?: true)]
      herd = described_class.new(env_double, config_double, members_double)

      expect(herd.gathered?).to be true
    end
    it 'returns false when any herd member is ungathered' do
      config_double = double(repos: [double(path: '/tmp/foo', revision: 'foo'),
                                     double(path: '/tmp/bar', revision: 'bar')])
      members_double = [double(gathered?: false), double(gathered?: true)]
      herd = described_class.new(env_double, config_double, members_double)

      expect(herd.gathered?).to be false
    end
  end
end
