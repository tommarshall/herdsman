module Herdsman
  class HerdMemberConfig
    def initialize(args = {})
      @args = args
      validate!
    end

    def path
      args.fetch('path')
    rescue
      args
    end

    def name
      args.fetch('name')
    rescue
      default_name
    end

    def revision
      args.fetch('revision')
    rescue
      default_revision
    end

    def fetch_cache
      args.fetch('fetch_cache').to_i
    rescue
      default_fetch_cache
    end

    private

    attr_reader :args

    def default_name
      File.basename(path)
    end

    def default_revision
      'master'
    end

    def default_fetch_cache
      0
    end

    def validate!
      raise 'Invalid repo config, path is required' unless path.is_a?(String)
    end
  end
end
