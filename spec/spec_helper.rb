require 'rspec'
require 'herdsman'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

def config_fixture_path(config_name)
  File.dirname(__FILE__) + "/fixtures/config/#{config_name}/herdsman.yml"
end

def env_double
  double(git_command: '/usr/bin/env git')
end
