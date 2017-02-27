require 'thor'

module Herdsman
  class CLI < Thor
    require 'herdsman'

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
      Herdsman::Config.new(File.expand_path('herdsman.yml', Dir.pwd))
    rescue
      $stderr.puts "ERROR: #{$!.message}"
      exit 1
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
      repos.map do |repo|
        Herdsman::HerdMember.new(
          Herdsman::GitRepo.new(env, repo.path),
          repo.revision,
          repo.fetch_cache,
        )
      end
    end
  end
end
