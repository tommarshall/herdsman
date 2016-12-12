require 'spec_helper'
require 'herdsman'

describe Herdsman::Environment do
  describe '#git_command' do
    it 'defaults to "/usr/bin/env git"' do
      env = described_class.new

      expect(env.git_command).to eq '/usr/bin/env git'
    end

    it 'can be overridden' do
      env = described_class.new
      env.git_command = '/path/to/git'

      expect(env.git_command).to eq '/path/to/git'
    end
  end
end
