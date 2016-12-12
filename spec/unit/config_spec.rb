require 'spec_helper'
require 'herdsman/config'

describe Herdsman::Config do
  describe '#repos' do
    context 'with repos' do
      it 'returns a list of repo objects' do
        config = described_class.new(config_fixture_path('valid'))

        expect(config.repos.is_a?(Array)).to be true
        expect(config.repos.size).to be(1)
      end

      it 'returns objects with path' do
        config = described_class.new(config_fixture_path('valid'))

        expect(config.repos[0].path).to eq('/tmp')
      end

      it 'returns objects with revision' do
        config = described_class.new(config_fixture_path('valid'))

        expect(config.repos[0].revision).to eq('a-branch')
      end
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
