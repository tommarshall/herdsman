module Herdsman
  class Herd
    attr_reader :members
    def initialize(env, config, members)
      @env     = env
      @config  = config
      @members = members
    end

    def gathered?
      members.all?(&:gathered?)
    end

    private

    attr_reader :env
  end
end
