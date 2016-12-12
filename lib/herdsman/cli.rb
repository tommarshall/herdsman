require 'thor'

module Herdsman
  class CLI < Thor
    require 'herdsman'

    default_task :status

    desc 'status', 'Check the status of the repositories in the herd'
    def status
      cmd = Herdsman::Command::Status.new(herd: herd, reporter: reporter)
      report = cmd.run
      $stderr.puts report.to_s
      exit report.has_warnings? ? 1 : 0
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
      Herdsman::Herd.new(env, config)
    end

    def reporter
      Herdsman::Reporter.new
    end
  end
end
