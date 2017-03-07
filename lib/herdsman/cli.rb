require 'thor'

module Herdsman
  class CLI < Thor
    require 'herdsman'

    class_option :fetch_cache, type: :numeric, banner: 'SECONDS', aliases: :c
    class_option :quiet, type: :boolean, aliases: :q

    default_task :status

    desc 'status', 'Check the status of the repositories in the herd'
    def status
      cmd = Herdsman::Command::Status.new(herd: herd, logger: logger)
      result = cmd.run
      exit result
    end

    desc 'version', 'Show the herdsman version'
    map %w(-v --version) => :version
    def version
      puts "Herdsman version #{Herdsman::VERSION}"
    end

    private

    def config
      path = File.expand_path('herdsman.yml', Dir.pwd)
      Herdsman::Config.new(path, config_overrides)
    rescue
      $stderr.puts "ERROR: #{$!.message}"
      exit 1
    end

    def config_overrides
      options.select { |key, _| %w(fetch_cache).include? key }
    end

    def env
      Herdsman::Environment.new
    end

    def herd
      Herdsman::Herd.new(env, config, herd_members(config.repos))
    end

    def logger
      writer = Logger.new(STDOUT)
      writer.formatter = proc do |severity, _, _, msg|
        "#{severity.upcase}: #{msg}\n"
      end
      logger = Herdsman::LogAdapter.new(writer)
      logger.adjust_verbosity(quiet: options[:quiet])
      logger
    end

    def herd_members(repos)
      repos.map do |herd_member_config|
        Herdsman::HerdMember.new(
          Herdsman::GitRepo.new(env, herd_member_config.path),
          herd_member_config,
        )
      end
    end
  end
end
