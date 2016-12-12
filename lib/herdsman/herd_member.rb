module Herdsman
  class HerdMember
    attr_reader :name
    def initialize(repo, revision, args = {})
      @repo     = repo
      @revision = revision
      @name     = args[:name] || default_name
      @messages = []
    end

    def status_report
      check_initialized
      check_for_unpushed_commits
      check_for_unpulled_commits
      check_for_untracked_files
      check_for_modified_files
      check_current_revision
      add_ok_message if messages.empty?
      messages
    end

    private

    attr_reader :repo, :revision, :messages

    def default_name
      File.basename(repo.path)
    end

    Message = Struct.new(:level, :msg)

    def add_ok_message
      @messages << Message.new(:info, "#{name} is ok")
    end

    def check_initialized
      unless repo.initialized?
        @messages << Message.new(:warn, "#{repo.path} is not a git repo")
      end
    end

    def check_for_unpushed_commits
      if repo.has_unpushed_commits?
        @messages << Message.new(:warn, "#{name} has unpushed commits")
      end
    end

    def check_for_unpulled_commits
      if repo.has_unpulled_commits?
        @messages << Message.new(:warn, "#{name} has unpulled commits")
      end
    end

    def check_for_untracked_files
      if repo.has_untracked_files?
        @messages << Message.new(:warn, "#{name} has untracked files")
      end
    end

    def check_for_modified_files
      if repo.has_modified_files?
        @messages << Message.new(:warn, "#{name} has modified files")
      end
    end

    def check_current_revision
      if repo.initialized? && !repo.revision?(revision)
        @messages << Message.new(:warn, "#{name} revision is not '#{revision}'")
      end
    end
  end
end
