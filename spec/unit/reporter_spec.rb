require 'spec_helper'
require 'herdsman'

describe Herdsman::Reporter do
  let(:info_message) { double(level: :info, msg: 'Success!') }
  let(:warn_message) { double(level: :warn, msg: 'Uh oh!') }
  let(:messages) { [info_message, warn_message] }

  describe '#add_messages' do
    it 'adds the messages to list' do
      reporter = described_class.new
      reporter.add_messages(messages)

      expect(reporter.messages).to eq messages
    end
  end

  describe '#to_s' do
    context 'with messages' do
      it 'returns the messages as a formatted string' do
        reporter = described_class.new
        reporter.add_messages(messages)

        expect(reporter.to_s).to include(warn_message.msg)
        expect(reporter.to_s).to include(info_message.msg)
      end

      it 'prefixes warning messages with WARN:' do
        reporter = described_class.new
        reporter.add_messages([warn_message])

        expect(reporter.to_s).to eq("WARN: #{warn_message.msg}")
      end

      it 'prefixes info messages with INFO:' do
        reporter = described_class.new
        reporter.add_messages([info_message])

        expect(reporter.to_s).to eq("INFO: #{info_message.msg}")
      end
    end

    context 'without messages' do
      it 'does not print any messages' do
        reporter = described_class.new
        expect(reporter.to_s).to eq('')
      end
    end
  end

  describe '#has_warnings?' do
    context 'with warning messages' do
      it 'returns true' do
        reporter = described_class.new
        reporter.add_messages(messages)

        expect(reporter).to have_warnings
      end
    end

    context 'with info messages only' do
      it 'returns false' do
        reporter = described_class.new
        reporter.add_messages([info_message])

        expect(reporter).to_not have_warnings
      end
    end

    context 'with no messages only' do
      it 'returns false' do
        reporter = described_class.new

        expect(reporter).to_not have_warnings
      end
    end
  end
end
