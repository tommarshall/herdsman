module Herdsman
  class LogAdapter
    attr_accessor :writer

    LOG_LEVELS = {
      debug: ::Logger::DEBUG,
      info:  ::Logger::INFO,
      warn:  ::Logger::WARN,
      error: ::Logger::ERROR,
    }.freeze

    def log_level
      writer.level
    end

    def log_level=(level)
      writer.level = LOG_LEVELS.fetch(level)
    end

    def adjust_verbosity(options = {})
      if options[:quiet]
        self.log_level = :error
      end
    end

    def initialize(writer)
      @writer = writer
    end

    def debug(message)
      writer.debug(message)
    end

    def info(message)
      writer.info(message)
    end

    def warn(message)
      writer.warn(message)
    end

    def error(message)
      writer.error(message)
    end
  end
end
