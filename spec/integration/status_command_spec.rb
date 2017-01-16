require 'spec_helper'

RSpec.describe '`herdsman status`', type: :aruba do
  context 'when gathered' do
    before do
      repo_double = TestGitRepo.new('foo')
      write_file 'herdsman.yml', <<-H
        repos:
          - #{repo_double.path}
      H
      run 'herdsman status'
      stop_all_commands
    end

    it 'reports info messages without warnings' do
      output = all_commands.map(&:output).join("\n")

      expect(output).to include('INFO: foo.git is ok')
      expect(output).to_not include('WARN:')
    end

    it 'exits without an error code' do
      expect(last_command_started).to have_exit_status(0)
    end
  end

  context 'when ungathered' do
    before do
      foo_repo_double = TestGitRepo.new('foo')
      bar_repo_double = TestGitRepo.new('bar')
      bar_repo_double.checkout_branch('foo-feature')
      foo_commit_sha = foo_repo_double.head_commit_sha
      foo_repo_double.write_file('foo.txt', 'foo')
      foo_repo_double.commit_file('foo.txt')
      foo_repo_double.push
      foo_repo_double.reset_hard(foo_commit_sha)
      foo_repo_double.write_file('foo.txt', 'baz')
      foo_repo_double.commit_file('foo.txt')
      foo_repo_double.write_file('foo.txt', 'qux')
      foo_repo_double.write_file('bar.txt', 'bar')
      write_file 'herdsman.yml', <<-H
        repos:
          - /tmp
          - path: #{foo_repo_double.path}
            revision: 'baz-revision'
          - #{bar_repo_double.path}
      H
      run 'herdsman status'
      stop_all_commands
    end

    it 'reports warnings' do
      output = all_commands.map(&:output).join("\n")

      expect(output).to include('WARN: /tmp is not a git repo')
      expect(output).to include("WARN: foo.git revision is not 'baz-revision'")
      expect(output).to include('WARN: foo.git has unpushed commits')
      expect(output).to include('WARN: foo.git has unpulled commits')
      expect(output).to include('WARN: foo.git has untracked files')
      expect(output).to include('WARN: foo.git has modified files')
      expect(output).to include("WARN: bar.git revision is not 'master'")
    end

    it 'exits with an error code' do
      expect(last_command_started).to have_exit_status(1)
    end
  end

  context '`-q`' do
    before do
      repo_double = TestGitRepo.new('bar')
      repo_double.checkout_branch('foo-feature')
      write_file 'herdsman.yml', <<-H
        repos:
          - #{repo_double.path}
      H
      run 'herdsman status -q'
      stop_all_commands
    end

    it 'supresses output' do
      output = all_commands.map(&:output).join("\n")

      expect(output).to eq('')
    end
  end

  context 'without a herdsman.yml config file' do
    it 'reports and error and exits with an error code' do
      run 'herdsman status'
      stop_all_commands
      output = all_commands.map(&:output).join("\n")

      expect(output).to include('ERROR: No config found')
    end
  end

  context 'with an invalid herdsman.yml config file' do
    it 'reports and error and exits with an error code' do
      write_file 'herdsman.yml', 'invalid'

      run 'herdsman status'
      stop_all_commands
      output = all_commands.map(&:output).join("\n")

      expect(output).to include('ERROR: Invalid config')
    end
  end
end
