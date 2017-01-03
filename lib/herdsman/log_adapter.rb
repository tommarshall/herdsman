module Herdsman
  class LogAdapter
    attr_accessor :writer
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
