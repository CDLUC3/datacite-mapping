# frozen_string_literal: true

require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Represents a DataCite "date" value, which can be a year, date (year-month-day or just year-month),
    # or ISO8601 datetime.
    #
    # @!attribute [r] year
    #   @return [Integer] The year.
    # @!attribute [r] month
    #   @return [Integer, nil] The month. Can be `nil` if no month was specified.
    # @!attribute [r] day
    #   @return [Integer, nil] The day. Can be `nil` if no day was specified.
    # @!attribute [r] hour
    #   @return [Integer, nil] The hour. Can be `nil` if no hour was specified.
    # @!attribute [r] minute
    #   @return [Integer, nil] The minutes. Can be `nil` if no minutes were specified.
    # @!attribute [r] sec
    #   @return [Integer, nil] The seconds. Can be `nil` if no seconds were specified.
    # @!attribute [r] nsec
    #   @return [Integer, nil] The nanoseconds. Can be `nil` if no nanoseconds were specified.
    class DateValue
      include Comparable

      attr_reader :year
      attr_reader :month
      attr_reader :day
      attr_reader :hour
      attr_reader :minute
      attr_reader :sec
      attr_reader :nsec
      attr_reader :date
      attr_reader :zone
      attr_reader :iso_value

      # Creates a new {DateValue}.
      #
      # @param val [DateTime, Date, Integer, String] The value, as a `DateTime`, `Date`, or `Integer`,
      #   or as a `String` in any [W3C DateTime format](http://www.w3.org/TR/NOTE-datetime)
      def initialize(val) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        datetime = to_datetime(val)
        @date = datetime ? datetime.to_date : to_date(val)
        @year = to_year(val)
        @month = to_month(val)
        @day = to_day(val)
        @iso_value = val.respond_to?(:iso8601) ? val.iso8601 : val.to_s
        if datetime && iso_value.include?('T')
          @hour = datetime.hour
          @minute = datetime.minute
          @sec = datetime.sec
          @nsec = datetime.to_time.nsec
          @zone = datetime.zone
        end
        raise ArgumentError, "Unable to parse date value '#{val}'" unless @year
      end

      def <=>(other)
        return nil unless other.class == self.class
        %i[year month day hour minute sec nsec].each do |v|
          order = send(v) <=> other.send(v)
          return order if order.nonzero?
        end
        0
      end

      def hash
        [year, month, day, hour, minute, sec, nsec, zone].hash
      end

      def to_s
        @str_value = begin
          str_value = iso_value
          if nsec && nsec != 0
            frac_str = (nsec / 1e9).to_s.sub('0', '')
            str_value.sub!(/(T[0-9]+:[0-9]+:[0-9]+)/, "\\1#{frac_str}") unless str_value.include?(frac_str)
          end
          str_value
        end
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
        matchdata = val.to_s.match(/^[0-9]+-([0-9]{2})(?![0-9])/)
        matchdata[1].to_i if matchdata
      end

      def to_day(val)
        return val.day if val.respond_to?(:day)
        matchdata = val.to_s.match(/^[0-9]+-[0-9]{2}-([0-9]{2})(?![0-9])/)
        matchdata[1].to_i if matchdata
      end

      def to_datetime(val)
        return val if val.is_a?(DateTime)
        DateTime.parse(val.to_s)
      rescue ArgumentError
        nil
      end

      def to_date(val)
        return val if val.is_a?(::Date)
        return ::Date.parse(val.iso8601) if val.respond_to?(:iso8601)
        ::Date.parse(val.to_s)
      rescue ArgumentError
        nil
      end

    end
  end
end
