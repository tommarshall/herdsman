require 'spec_helper'
require 'herdsman'

describe Herdsman::LogAdapter do
  describe '#debug' do
    it 'calls #debug on writer and returns true' do
      writer = double
      logger = Herdsman::LogAdapter.new(writer)

      expect(writer).to receive(:debug).with('log message').and_return(true)
      logger.debug('log message')
    end
  end

  describe '#info' do
    it 'calls #info on writer and returns true' do
      writer = double
      logger = Herdsman::LogAdapter.new(writer)

      expect(writer).to receive(:info).with('log message').and_return(true)
      logger.info('log message')
    end
  end

  describe '#warn' do
    it 'calls #warn on writer and returns true' do
      writer = double
      logger = Herdsman::LogAdapter.new(writer)

      expect(writer).to receive(:warn).with('log message').and_return(true)
      logger.warn('log message')
    end
  end

  describe '#error' do
    it 'calls #error on writer and returns true' do
      writer = double
      logger = Herdsman::LogAdapter.new(writer)

      expect(writer).to receive(:error).with('log message').and_return(true)
      logger.error('log message')
    end
  end
end
