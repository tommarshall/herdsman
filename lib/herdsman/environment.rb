module Herdsman
  class Environment
    DEFAULT_GIT_COMMAND = '/usr/bin/env git'.freeze

    attr_accessor :git_command
    def initialize
      @git_command = DEFAULT_GIT_COMMAND
    end
  end
end
