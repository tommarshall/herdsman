require 'spec_helper'
require 'herdsman'

describe Herdsman::LogAdapter do
  class LoggerDouble
    attr_accessor :level

    def debug(*); end

    def info(*); end

    def warn(*); end

    def error(*); end
  end

  describe '#log_level' do
    it 'calls #level on writer' do
      writer = LoggerDouble.new
      logger = Herdsman::LogAdapter.new(writer)

      expect(writer).to receive(:level)
      logger.log_level
    end
  end

  describe '#log_level=' do
    it "sets the writer's logging level" do
      logger = Herdsman::LogAdapter.new(LoggerDouble.new)

      logger.log_level = :error

      expect(Herdsman::LogAdapter::LOG_LEVELS[:error]).to eq(logger.log_level)
    end
  end

  describe '#adjust_verbosity' do
    it "sets the writer's logging level to error when quiet" do
      logger = Herdsman::LogAdapter.new(LoggerDouble.new)

      logger.adjust_verbosity(quiet: true)

      expect(Herdsman::LogAdapter::LOG_LEVELS[:error]).to eq(logger.log_level)
    end
    it "does not change the writer's logging when not quiet" do
      logger = Herdsman::LogAdapter.new(LoggerDouble.new)
      original_level = logger.log_level

      logger.adjust_verbosity(quiet: false)

      expect(original_level).to eq(logger.log_level)
    end
  end

  describe '#debug' do
    it 'calls #debug on writer and returns true' do
      writer = LoggerDouble.new
      logger = Herdsman::LogAdapter.new(writer)

      expect(writer).to receive(:debug).with('log message').and_return(true)
      logger.debug('log message')
    end
  end

  describe '#info' do
    it 'calls #info on writer and returns true' do
      writer = LoggerDouble.new
      logger = Herdsman::LogAdapter.new(writer)

      expect(writer).to receive(:info).with('log message').and_return(true)
      logger.info('log message')
    end
  end

  describe '#warn' do
    it 'calls #warn on writer and returns true' do
      writer = LoggerDouble.new
      logger = Herdsman::LogAdapter.new(writer)

      expect(writer).to receive(:warn).with('log message').and_return(true)
      logger.warn('log message')
    end
  end

  describe '#error' do
    it 'calls #error on writer and returns true' do
      writer = LoggerDouble.new
      logger = Herdsman::LogAdapter.new(writer)

      expect(writer).to receive(:error).with('log message').and_return(true)
      logger.error('log message')
    end
  end
end
