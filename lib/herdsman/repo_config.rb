module Herdsman
  class RepoConfig
    def initialize(args = {})
      @args = args
      validate!
    end

    def path
      args.fetch('path')
    rescue
      args
    end

    def revision
      args.fetch('revision')
    rescue
      default_revision
    end

    private

    attr_reader :args

    def default_revision
      'master'
    end

    def validate!
      raise 'Invalid repo config, path is required' unless path.is_a?(String)
    end
  end
end
