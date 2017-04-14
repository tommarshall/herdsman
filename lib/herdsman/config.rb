require 'yaml'
require 'herdsman/herd_member_config'

module Herdsman
  class Config
    def initialize(path, overrides = {})
      @config    = read_config!(path)
      @overrides = overrides
      validate!
    end

    def repos
      config_repos.map do |herd_member_config|
        HerdMemberConfig.new(herd_member_path(herd_member_config),
                             herd_member_args(herd_member_config),
                             overrides, config_defaults)
      end
    end

    private

    attr_reader :config, :overrides

    def read_config!(path)
      YAML.load_file(path)
    rescue
      raise 'No config found'
    end

    def config_defaults
      config.fetch('defaults')
    rescue
      {}
    end

    def config_repos
      config['repos'] || config['repositories'] || []
    end

    def herd_member_path(herd_member_config)
      herd_member_config.fetch('path')
    rescue
      herd_member_config
    end

    def herd_member_args(herd_member_config)
      herd_member_config.select { |key, _| key != 'path' }
    rescue
      {}
    end

    def validate!
      raise 'Invalid config' unless config.is_a?(Hash) && repos.is_a?(Array)
      raise 'No repos defined' if repos.empty?
      repos.each do |repo|
        unless File.directory?(repo.path)
          raise "#{repo.path} is not a directory"
        end
      end
    end
  end
end
