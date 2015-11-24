require 'xml/mapping_extensions'

module Datacite
  module Mapping
    class Date
      include XML::Mapping

      text_node :_value, 'text()'

      attr_reader :year
      attr_reader :month
      attr_reader :day
      attr_reader :hour
      attr_reader :minute
      attr_reader :sec
      attr_reader :nsec

      def initialize(value:)
        self.value = value
      end

      def value=(val) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        @date_time = to_datetime(val)
        @date = @date_time ? @date_time.to_date : to_date(val)
        @year = to_year(val)
        @month = to_month(val)
        @day = to_day(val)
        new_value = val.respond_to?(:iso8601) ? val.iso8601 : val.to_s
        if new_value.include?('T')
          @hour = @date_time.hour if @date_time
          @minute = @date_time.minute if @date_time
          @sec = @date_time.sec if @date_time
          @nsec = @date_time.to_time.nsec if @date_time
        end
        fail ArgumentError, "Unable to parse date value '#{val}'" unless @year
        self._value = new_value
      end

      def value
        _value
      end

      private

      def to_year(val)
        return val if val.is_a?(Integer)
        return val.year if val.respond_to?(:year)
        matchdata = val.to_s.match(/^[0-9]+/)
        matchdata[0].to_i if matchdata
      end

      def to_month(val)
        return val.month if val.respond_to?(:month)
        matchdata = val.to_s.match(/^[0-9]+-([0-9]+)/)
        matchdata[1].to_i if matchdata
      end

      def to_day(val)
        return val.day if val.respond_to?(:day)
        matchdata = val.to_s.match(/^[0-9]+-[0-9]+-([0-9]+)/)
        matchdata[1].to_i if matchdata
      end

      def to_datetime(val)
        return val if val.is_a?(DateTime)
        DateTime.parse(val.to_s)
      rescue ArgumentError => e
        Mapping.log.debug("Can't extract DateTime from date value '#{val}': #{e}")
        nil
      end

      def to_date(val)
        return val if val.is_a?(::Date)
        return ::Date.parse(val.iso8601) if val.respond_to?(:iso8601)
        ::Date.parse(val.to_s)
      rescue ArgumentError => e
        Mapping.log.debug("Can't extract Date from date value '#{val}': #{e}")
        nil
      end

    end
  end
end
