module Herdsman
  class Herd
    attr_reader :members
    def initialize(env, config)
      @env = env
      @config = config
      @members = load_members(config.repos)
    end

    private

    attr_reader :env

    def load_members(repos)
      repos.map do |repo|
        Herdsman::HerdMember.new(
          Herdsman::GitRepo.new(env, repo.path),
          repo.revision,
        )
      end
    end
  end
end
