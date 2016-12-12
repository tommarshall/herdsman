require 'spec_helper'
require 'herdsman'

describe Herdsman::GitRepo do
  describe '#initialized?' do
    it 'returns true when the path is a git repository' do
      repo_double = TestGitRepo.new('foo')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo).to be_initialized
    end
    it 'returns false when the path is not a git repository' do
      repo = described_class.new(env_double, '/tmp')

      expect(repo).to_not be_initialized
    end
  end

  describe '#path' do
    it 'returns the full path' do
      repo_double = TestGitRepo.new('foo')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo.path).to eq repo_double.path
    end
  end

  describe '#git_dir' do
    it 'returns the path to the .git directory' do
      repo_double = TestGitRepo.new('foo')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo.git_dir).to eq '.git'
    end
  end

  describe '#current_head' do
    it 'returns the name of the current git branch' do
      repo_double = TestGitRepo.new('foo')
      repo_double.checkout_branch('feature-foo')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo.current_head).to eq 'feature-foo'
    end
    it 'returns the name of an tag if there is no branch' do
      repo_double = TestGitRepo.new('foo')
      repo_double.checkout_tag('tag-foo')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo.current_head).to eq 'tag-foo'
    end
    it 'returns the abbreviated commit_ref if there is no branch or tag' do
      repo_double = TestGitRepo.new('foo')
      commit_sha = repo_double.head_commit_sha
      repo_double.checkout_commit(commit_sha)
      repo = described_class.new(env_double, repo_double.path)

      expect(repo.current_head).to eq commit_sha
    end
    it 'returns nil in an uninitialized repository' do
      repo = described_class.new(env_double, '/tmp')

      expect(repo.current_head).to be_nil
    end
  end

  describe '#has_untracked_files?' do
    it 'returns true when there are untracked files in the repository' do
      repo_double = TestGitRepo.new('foo')
      repo_double.write_file('untracked.txt', 'An untracked file')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo).to have_untracked_files
    end
    it 'returns false when there are no untracked files in the repository' do
      repo_double = TestGitRepo.new('foo')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo).not_to have_untracked_files
    end
  end

  describe '#has_modified_files?' do
    it 'returns true when there are modified files' do
      repo_double = TestGitRepo.new('foo')
      repo_double.write_file('foo.txt', 'Modifications')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo).to have_modified_files
    end
    it 'returns false when there no modified files' do
      repo_double = TestGitRepo.new('foo')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo).not_to have_modified_files
    end
  end

  describe '#has_unpushed_commits?' do
    it 'returns true when there are unpushed commits' do
      repo_double = TestGitRepo.new('foo')
      repo_double.write_file('foo.txt', 'Modifications')
      repo_double.commit_file('foo.txt')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo).to have_unpushed_commits
    end
    it 'returns false when there no unpushed commits' do
      repo_double = TestGitRepo.new('foo')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo).to_not have_unpushed_commits
    end
  end

  describe '#has_unpulled_commits?' do
    it 'returns true when there are unpulled commits' do
      repo_double = TestGitRepo.new('foo')
      commit_sha = repo_double.head_commit_sha
      repo_double.write_file('foo.txt', 'Modifications')
      repo_double.commit_file('foo.txt')
      repo_double.push
      repo_double.reset_hard(commit_sha)
      repo = described_class.new(env_double, repo_double.path)

      expect(repo).to have_unpulled_commits
    end
    it 'returns false when there no unpulled commits' do
      repo_double = TestGitRepo.new('foo')
      repo = described_class.new(env_double, repo_double.path)

      expect(repo).to_not have_unpulled_commits
    end
  end

  describe '#revision?' do
    before do
      repo_double = TestGitRepo.new('foo')
      repo_double.tag('v1.0.0')
      @commit_sha = repo_double.head_commit_sha
      @repo = described_class.new(env_double, repo_double.path)
    end
    it 'returns true when HEAD is the branch' do
      expect(@repo.revision?('master')).to be true
    end
    it 'returns false when HEAD is not the branch' do
      expect(@repo.revision?('not-a-branch')).to be false
    end
    it 'returns true when HEAD is the tag' do
      expect(@repo.revision?('v1.0.0')).to be true
    end
    it 'returns false when HEAD is not the tag' do
      expect(@repo.revision?('not-a-tag')).to be false
    end
    it 'returns true when HEAD is the commit_ref' do
      expect(@repo.revision?(@commit_sha)).to be true
    end
    it 'returns false when HEAD is not the commit_ref' do
      expect(@repo.revision?('notaSHA')).to be false
    end
    it 'returns false in an uninitialized repository' do
      repo = described_class.new(env_double, '/tmp')
      expect(repo.revision?('master')).to be false
    end
  end
end
