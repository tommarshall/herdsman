require 'spec_helper'
require 'herdsman'

describe Herdsman::Herd do
  describe '#members' do
    it 'returns an enumerable of Herdsman::HerdMember objects' do
      config_double = double(repos: [double(path: '/tmp/foo', revision: 'foo'),
                                     double(path: '/tmp/bar', revision: 'bar')])
      herd = described_class.new(env_double, config_double)
      members = herd.members

      expect(members.is_a?(Array)).to be true
      expect(members.size).to be 2
      expect(members.first.is_a?(Herdsman::HerdMember)).to be true
    end
  end
end
