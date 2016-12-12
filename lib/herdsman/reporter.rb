module Herdsman
  class Reporter
    attr_accessor :messages
    def initialize
      @messages = []
    end

    def add_messages(msgs)
      @messages += msgs
    end

    def to_s
      messages.map do |message|
        "#{message_prefix(message)}: #{message.msg}"
      end.join("\n") || ''
    end

    def has_warnings?
      messages.map(&:level).include?(:warn)
    end

    private

    def message_prefix(message)
      message.level.to_s.upcase
    end
  end
end
