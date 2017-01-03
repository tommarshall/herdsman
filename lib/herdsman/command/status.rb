module Herdsman
  module Command
    class Status
      def initialize(args = {})
        @herd   = args[:herd]
        @logger = args[:logger]
      end

      def run
        herd.members.each do |herd_member|
          herd_member.status_report.each do |message|
            logger.send(message.level, message.msg)
          end
        end
        herd.gathered?
      end

      private

      attr_reader :herd, :logger
    end
  end
end
