require 'spec_helper'
require 'herdsman/herd_member_config'

describe Herdsman::HerdMemberConfig do
  describe '#path' do
    it 'returns the path' do
      herd_member_config = described_class.new('/foo/path')

      expect(herd_member_config.path).to eq('/foo/path')
    end
  end
  describe '#name' do
    it 'defaults to the directory name' do
      herd_member_config = described_class.new('/foo/path')

      expect(herd_member_config.name).to eq 'path'
    end
    it 'returns the name option' do
      args = { 'name' => 'bar' }
      herd_member_config = described_class.new('foo/path', args)

      expect(herd_member_config.name).to eq 'bar'
    end
  end
  describe '#revision' do
    it 'defaults to master' do
      herd_member_config = described_class.new('/foo/path')

      expect(herd_member_config.revision).to eq('master')
    end
    it 'returns the revision option' do
      args = { 'revision' => 'bar' }
      herd_member_config = described_class.new('/foo/path', args)

      expect(herd_member_config.revision).to eq('bar')
    end
    context 'with override' do
      it 'returns the override value' do
        args = { 'revision' => 'master' }
        overrides = { 'revision' => 'foo-revision' }
        repo_config = described_class.new('/foo/path', args, overrides)

        expect(repo_config.revision).to eq('foo-revision')
      end
    end
    context 'with default' do
      it 'favours the arg value' do
        args = { 'revision' => 'foo' }
        defaults = { 'revision' => 'bar' }
        herd_member_config = described_class.new('/foo/path', args, {},
                                                 defaults)

        expect(herd_member_config.revision).to eq('foo')
      end
      it 'returns the specified value if no arg provided' do
        defaults = { 'revision' => 'bar' }
        herd_member_config = described_class.new('/foo/path', {}, {}, defaults)

        expect(herd_member_config.revision).to eq('bar')
      end
    end
  end
  describe '#fetch_cache' do
    it 'defaults to 0' do
      repo_config = described_class.new('/foo/path')

      expect(repo_config.fetch_cache).to eq(0)
    end
    context 'with int' do
      it 'returns the fetch_cache option as an int' do
        args = { 'fetch_cache' => 300 }
        repo_config = described_class.new('/foo/path', args)

        expect(repo_config.fetch_cache).to eq(300)
      end
    end
    context 'with float' do
      it 'returns the fetch_cache option as an int' do
        args = { 'fetch_cache' => 300.1 }
        repo_config = described_class.new('/foo/path', args)

        expect(repo_config.fetch_cache).to eq(300)
      end
    end
    context 'with unconvertable format' do
      it 'returns the default' do
        args = { 'fetch_cache' => true }
        repo_config = described_class.new('/foo/path', args)

        expect(repo_config.fetch_cache).to eq(0)
      end
    end
    context 'with override' do
      it 'returns the override value' do
        args = { 'fetch_cache' => 0 }
        overrides = { 'fetch_cache' => 300 }
        repo_config = described_class.new('/foo/path', args, overrides)

        expect(repo_config.fetch_cache).to eq(300)
      end
    end
    context 'with default' do
      it 'favours the arg value' do
        args = { 'fetch_cache' => 300 }
        defaults = { 'fetch_cache' => 100 }
        herd_member_config = described_class.new('/foo/path', args, {},
                                                 defaults)

        expect(herd_member_config.fetch_cache).to eq(300)
      end
      it 'returns the specified value if no arg provided' do
        defaults = { 'fetch_cache' => 100 }
        herd_member_config = described_class.new('/foo/path', {}, {}, defaults)

        expect(herd_member_config.fetch_cache).to eq(100)
      end
    end
  end
  context 'with no path' do
    it 'raises an exception' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
