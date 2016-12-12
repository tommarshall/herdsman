module Herdsman
  module Command
    class Status
      def initialize(args = {})
        @herd     = args[:herd]
        @reporter = args[:reporter]
      end

      def run
        herd.members.each do |herd_member|
          reporter.add_messages(herd_member.status_report)
        end
        reporter
      end

      private

      attr_reader :herd, :reporter
    end
  end
end
