require 'spec_helper'
require 'herdsman/repo_config'

describe Herdsman::RepoConfig do
  describe '#path' do
    context 'with hash' do
      it 'returns the path' do
        options = { 'path' => '/foo/path' }
        repo_config = described_class.new(options)

        expect(repo_config.path).to eq('/foo/path')
      end
    end
    context 'with string' do
      it 'returns the path' do
        options = '/foo/path'
        repo_config = described_class.new(options)

        expect(repo_config.path).to eq('/foo/path')
      end
    end
  end
  describe '#revision' do
    it 'defaults to master' do
      options = { 'path' => '/foo/path' }
      repo_config = described_class.new(options)

      expect(repo_config.revision).to eq('master')
    end
    it 'returns the revision option' do
      options = { 'path' => '/foo/path', 'revision' => 'bar' }
      repo_config = described_class.new(options)

      expect(repo_config.revision).to eq('bar')
    end
  end
  context 'with no options' do
    it 'raises an exception' do
      expect { described_class.new }.to raise_error(RuntimeError)
    end
  end
  context 'with invalid options' do
    it 'raises an exception' do
      options = { 'foo' => 'bar' }

      expect { described_class.new(options) }.to raise_error(RuntimeError)
    end
  end
end
