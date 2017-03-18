require 'spec_helper'
require 'herdsman/herd_member_config'

describe Herdsman::HerdMemberConfig do
  describe '#path' do
    context 'with hash' do
      it 'returns the path' do
        args = { 'path' => '/foo/path' }
        herd_member_config = described_class.new(args)

        expect(herd_member_config.path).to eq('/foo/path')
      end
    end
    context 'with string' do
      it 'returns the path' do
        args = '/foo/path'
        herd_member_config = described_class.new(args)

        expect(herd_member_config.path).to eq('/foo/path')
      end
    end
  end
  describe '#name' do
    it 'defaults to the directory name' do
      args = { 'path' => '/foo/path' }
      herd_member_config = described_class.new(args)

      expect(herd_member_config.name).to eq 'path'
    end
    it 'returns the name option' do
      args = { 'path' => '/foo/path', 'name' => 'bar' }
      herd_member_config = described_class.new(args)

      expect(herd_member_config.name).to eq 'bar'
    end
  end
  describe '#revision' do
    it 'defaults to master' do
      args = { 'path' => '/foo/path' }
      herd_member_config = described_class.new(args)

      expect(herd_member_config.revision).to eq('master')
    end
    it 'returns the revision option' do
      args = { 'path' => '/foo/path', 'revision' => 'bar' }
      herd_member_config = described_class.new(args)

      expect(herd_member_config.revision).to eq('bar')
    end
    context 'with override' do
      it 'returns the override value' do
        args = { 'path' => '/foo/path', 'revision' => 'master' }
        overrides = { 'revision' => 'foo-revision' }
        repo_config = described_class.new(args, overrides)

        expect(repo_config.revision).to eq('foo-revision')
      end
    end
    context 'with default' do
      it 'favours the arg value' do
        args = { 'path' => '/foo/path', 'revision' => 'foo' }
        defaults = { 'revision' => 'bar' }
        herd_member_config = described_class.new(args, {}, defaults)

        expect(herd_member_config.revision).to eq('foo')
      end
      it 'returns the specified value if no arg provided' do
        args = { 'path' => '/foo/path' }
        defaults = { 'revision' => 'bar' }
        herd_member_config = described_class.new(args, {}, defaults)

        expect(herd_member_config.revision).to eq('bar')
      end
    end
  end
  describe '#fetch_cache' do
    it 'defaults to 0' do
      args = { 'path' => '/foo/path' }
      repo_config = described_class.new(args)

      expect(repo_config.fetch_cache).to eq(0)
    end
    context 'with int' do
      it 'returns the fetch_cache option as an int' do
        args = { 'path' => '/foo/path', 'fetch_cache' => 300 }
        repo_config = described_class.new(args)

        expect(repo_config.fetch_cache).to eq(300)
      end
    end
    context 'with float' do
      it 'returns the fetch_cache option as an int' do
        args = { 'path' => '/foo/path', 'fetch_cache' => 300.1 }
        repo_config = described_class.new(args)

        expect(repo_config.fetch_cache).to eq(300)
      end
    end
    context 'with unconvertable format' do
      it 'returns the default' do
        args = { 'path' => '/foo/path', 'fetch_cache' => true }
        repo_config = described_class.new(args)

        expect(repo_config.fetch_cache).to eq(0)
      end
    end
    context 'with override' do
      it 'returns the override value' do
        args = { 'path' => '/foo/path', 'fetch_cache' => 0 }
        overrides = { 'fetch_cache' => 300 }
        repo_config = described_class.new(args, overrides)

        expect(repo_config.fetch_cache).to eq(300)
      end
    end
    context 'with default' do
      it 'favours the arg value' do
        args = { 'path' => '/foo/path', 'fetch_cache' => 300 }
        defaults = { 'fetch_cache' => 100 }
        herd_member_config = described_class.new(args, {}, defaults)

        expect(herd_member_config.fetch_cache).to eq(300)
      end
      it 'returns the specified value if no arg provided' do
        args = { 'path' => '/foo/path' }
        defaults = { 'fetch_cache' => 100 }
        herd_member_config = described_class.new(args, {}, defaults)

        expect(herd_member_config.fetch_cache).to eq(100)
      end
    end
  end
  context 'with no args' do
    it 'raises an exception' do
      expect { described_class.new }.to raise_error(RuntimeError)
    end
  end
  context 'with invalid args' do
    it 'raises an exception' do
      args = { 'foo' => 'bar' }

      expect { described_class.new(args) }.to raise_error(RuntimeError)
    end
  end
end
