require 'spec_helper'
require 'herdsman/config'
require 'herdsman/herd_member_config'

describe Herdsman::Config do
  describe '#repos' do
    context 'with repos' do
      it 'returns a list of HerdMemberConfig objects' do
        config = described_class.new(config_fixture_path('valid'))

        expect(config.repos).to all be_a Herdsman::HerdMemberConfig
      end
    end

    context 'with repositories alias' do
      it 'returns a list of HerdMemberConfig objects' do
        config = described_class.new(config_fixture_path('repositories-alias'))

        expect(config.repos).to all be_a Herdsman::HerdMemberConfig
      end
    end
  end

  context 'with overrides' do
    it 'passes the overrides to HerdMemberConfig' do
      args = { 'revision' => 'a-branch' }
      overrides = { fetch_cache: 300 }
      config = described_class.new(config_fixture_path('valid'), overrides)

      expect(Herdsman::HerdMemberConfig).to receive(:new).with('/tmp', args,
                                                               overrides, {})
      config.repos
    end
  end

  context 'with defaults' do
    it 'passes the defaults to HerdMemberConfig' do
      config = described_class.new(config_fixture_path('defaults'))
      args = { 'revision' => 'a-branch' }
      defaults = { 'revision' => 'a-tag', 'fetch_cache' => 300 }

      expect(Herdsman::HerdMemberConfig).to receive(:new).with('/tmp', args, {},
                                                               defaults)
      config.repos
    end
  end

  context 'with undefined repos' do
    it 'raises an exception' do
      expected = expect do
        described_class.new(config_fixture_path('undefined'))
      end

      expected.to raise_error(RuntimeError)
    end
  end

  context 'with zero repos' do
    it 'raises an exception' do
      expected = expect do
        described_class.new(config_fixture_path('empty'))
      end

      expected.to raise_error(RuntimeError)
    end
  end

  context 'with non-existant repo dirs' do
    it 'raises an exception' do
      expected = expect do
        described_class.new(config_fixture_path('non-existant'))
      end

      expected.to raise_error(RuntimeError)
    end
  end

  context 'when config file is invalid YAML' do
    it 'raises an exception' do
      expected = expect do
        described_class.new(config_fixture_path('invalid'))
      end

      expected.to raise_error(RuntimeError)
    end
  end

  context 'when config file does not exist' do
    it 'raises an exception' do
      expected = expect do
        described_class.new('not_a_file')
      end

      expected.to raise_error(RuntimeError)
    end
  end
end
