require 'yaml'
require 'herdsman/herd_member_config'

module Herdsman
  class Config
    def initialize(path)
      @config = read_config!(path)
      validate!
    end

    def repos
      config_repos = config['repos'] || config['repositories'] || []
      config_repos.map do |herd_member_config|
        HerdMemberConfig.new(herd_member_config)
      end
    end

    private

    attr_reader :config

    def read_config!(path)
      YAML.load_file(path)
    rescue
      raise 'No config found'
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
