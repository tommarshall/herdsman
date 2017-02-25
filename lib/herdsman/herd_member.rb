module Herdsman
  class HerdMember
    attr_reader :name
    def initialize(repo, revision, fetch_cache, args = {})
      @repo        = repo
      @revision    = revision
      @fetch_cache = fetch_cache
      @name        = args[:name] || default_name
    end

    def gathered?
      [repo_initialized?,
       repo_has_zero_unpushed_commits?,
       repo_has_zero_unpulled_commits?,
       repo_has_zero_untracked_files?,
       repo_has_zero_modified_files?,
       repo_on_specified_revision?].all?
    end

    def status_report
      clear_messages
      messages << Message.new(:info, "#{name} is ok") if gathered?
      messages
    end

    private

    attr_reader :repo, :revision, :fetch_cache

    def default_name
      File.basename(repo.path)
    end

    Message = Struct.new(:level, :msg)

    def messages
      @messages ||= []
    end

    def clear_messages
      @messages = []
    end

    def fetch_cached?
      Time.now - repo.last_fetched < fetch_cache
    end

    def repo_fetch!
      repo.fetch!
    rescue
      messages << Message.new(:warn, "#{name} failed to fetch")
    end

    def repo_initialized?
      unless repo.initialized?
        messages << Message.new(:warn, "#{repo.path} is not a git repo")
      end
      repo.initialized?
    end

    def repo_has_zero_unpushed_commits?
      if repo.has_unpushed_commits?
        messages << Message.new(:warn, "#{name} has unpushed commits")
      end
      !repo.has_unpushed_commits?
    end

    def repo_has_zero_unpulled_commits?
      repo_fetch! unless fetch_cached?
      if repo.has_unpulled_commits?
        messages << Message.new(:warn, "#{name} has unpulled commits")
      end
      !repo.has_unpulled_commits?
    end

    def repo_has_zero_untracked_files?
      if repo.has_untracked_files?
        messages << Message.new(:warn, "#{name} has untracked files")
      end
      !repo.has_untracked_files?
    end

    def repo_has_zero_modified_files?
      if repo.has_modified_files?
        messages << Message.new(:warn, "#{name} has modified files")
      end
      !repo.has_modified_files?
    end

    def repo_on_specified_revision?
      if repo.initialized? && !repo.revision?(revision)
        messages << Message.new(:warn, "#{name} revision is not '#{revision}'")
      end
      !repo.initialized? || repo.revision?(revision)
    end
  end
end
