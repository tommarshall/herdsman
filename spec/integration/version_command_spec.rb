require 'spec_helper'

RSpec.describe '`herdsman version`', type: :aruba do
  before :each do
    run 'herdsman version'
    stop_all_commands
  end

  it 'prints the version' do
    output = last_command_started.output

    expect(output).to match(/Herdsman version \d+\.\d+\.\d+/)
  end

  it 'exits without an error code' do
    expect(last_command_started).to have_exit_status(0)
  end
end
