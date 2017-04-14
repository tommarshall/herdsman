module Herdsman
  class HerdMemberConfig
    attr_reader :path
    def initialize(path, args = {}, overrides = {}, defaults = {})
      @path      = path
      @args      = args
      @overrides = overrides
      @defaults  = defaults
      validate!
    end

    def name
      args.fetch('name')
    rescue
      default_name
    end

    def revision
      overridable_arg('revision')
    rescue
      default_revision
    end

    def fetch_cache
      overridable_arg('fetch_cache').to_i
    rescue
      default_fetch_cache
    end

    private

    attr_reader :args, :overrides, :defaults

    def default_name
      File.basename(path)
    end

    def default_revision
      overridable_default('revision', 'master')
    end

    def default_fetch_cache
      overridable_default('fetch_cache', 0)
    end

    def overridable_default(arg, default)
      defaults.fetch(arg)
    rescue
      default
    end

    def overridable_arg(arg)
      overrides.fetch(arg)
    rescue
      args.fetch(arg)
    end

    def validate!
      raise 'Invalid repo config, path is required' unless path.is_a?(String)
    end
  end
end
