require 'yaml'

module Herdsman
  class Config
    def initialize(path)
      @config = read_config!(path)
      validate!
    end

    def repos
      config_repos = config['repos'] || config['repositories'] || []
      config_repos.map do |repo_config|
        RepoConfig.new(repo_config)
      end
    end

    private

    attr_reader :config

    class RepoConfig
      def initialize(repo_config)
        @repo_config = repo_config
      end

      def path
        if repo_config.is_a?(Hash)
          repo_config['path']
        else
          repo_config
        end
      end

      def revision
        if repo_config.is_a?(Hash) && repo_config.include?('revision')
          repo_config['revision']
        else
          default_revision
        end
      end

      private

      attr_reader :repo_config

      def default_revision
        'master'
      end
    end

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
