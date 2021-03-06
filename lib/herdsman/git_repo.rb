require 'open3'

module Herdsman
  class GitRepo
    attr_reader :path
    def initialize(env, path)
      @env  = env
      @path = path
    end

    def initialized?
      !git_dir.empty? && File.exist?(path + '/' + git_dir)
    end

    def git_dir
      git_output('rev-parse --git-dir')
    end

    def fetch!
      _, _, proc_status = git_command('fetch --all')
      raise 'Fetch failed' unless proc_status.exitstatus.zero?
    end

    def current_head
      current_branch_name || current_tag_name || abbreviated_commit_ref
    end

    def has_untracked_files?
      status.untracked_files.any?
    end

    def has_modified_files?
      status.modified_files.any?
    end

    def has_unpushed_commits?
      git_output('log --oneline @{u}..').lines.any?
    end

    def has_unpulled_commits?
      git_output('log --oneline ..@{u}').lines.any?
    end

    def revision?(revision)
      [current_branch_name, current_tag_name, abbreviated_commit_ref].include?(
        revision,
      )
    end

    def last_fetched
      File.mtime(File.join(File.expand_path(path, Dir.pwd), '.git/FETCH_HEAD'))
    rescue
      Time.at(0)
    end

    private

    attr_reader :env

    def current_branch_name
      branch_name = git_output('symbolic-ref HEAD --short')
      branch_name unless branch_name.empty?
    end

    def current_tag_name
      tag_name = git_output('describe --exact-match --tags HEAD')
      tag_name unless tag_name.empty?
    end

    def abbreviated_commit_ref
      commit_ref = git_output('rev-parse HEAD')
      commit_ref[0, 7].to_s unless commit_ref.empty?
    end

    def status
      StatusParser.new(git_output('status --porcelain'))
    end

    def git_output(command)
      git_command(command).first.chomp
    end

    def git_command(command)
      Dir.chdir(File.expand_path(path, Dir.pwd)) do
        Open3.capture3("#{env.git_command} #{command}")
      end
    end

    class StatusParser
      def initialize(status_porcelain)
        @status_porcelain = status_porcelain
      end

      def untracked_files
        status_porcelain.lines.select { |l| l.start_with?('??') }
      end

      def modified_files
        status_porcelain.lines.select { |l| l =~ /^ ?[A-Z]/ }
      end

      private

      attr_reader :status_porcelain
    end
  end
end
