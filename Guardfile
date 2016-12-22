guard :rspec, cmd: 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/herdsman/(.+)\.rb$}) { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('lib/herdsman/cli.rb')       { 'spec/integration' }
  watch('spec/spec_helper.rb')       { 'spec' }
end
