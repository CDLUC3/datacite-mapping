require 'spec_helper'

module Datacite
  module Mapping
    describe 'log' do
      it 'logs to stdout in a timestamp-first format' do
        out = StringIO.new
        Mapping.log_device = out
        begin
          msg = 'I am a log message'
          Mapping.log.warn(msg)
          logged = out.string
          expect(logged).to include(msg)
          timestamp_str = logged.split[0]
          timestamp = DateTime.parse(timestamp_str)
          expect(timestamp.to_date).to eq(Time.now.utc.to_date)
        ensure
          Mapping.log_device = $stdout
        end
      end
    end
  end
end
