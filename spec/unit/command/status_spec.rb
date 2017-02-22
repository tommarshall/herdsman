require 'spec_helper'
require 'herdsman/command/status'

describe Herdsman::Command::Status do
  it 'implements the command interface' do
    command = described_class.new

    expect(command).to respond_to(:run)
  end
end
