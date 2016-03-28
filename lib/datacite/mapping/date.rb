require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Controlled vocabulary of date types.
    class DateType < TypesafeEnum::Base
      # @!parse ACCEPTED = Accepted
      new :ACCEPTED, 'Accepted'

      # @!parse AVAILABLE = Available
      new :AVAILABLE, 'Available'

      # @!parse COPYRIGHTED = Copyrighted
      new :COPYRIGHTED, 'Copyrighted'

      # @!parse COLLECTED = Collected
      new :COLLECTED, 'Collected'

      # @!parse CREATED = Created
      new :CREATED, 'Created'

      # @!parse ISSUED = Issued
      new :ISSUED, 'Issued'

      # @!parse SUBMITTED = Submitted
      new :SUBMITTED, 'Submitted'

      # @!parse UPDATED = Updated
      new :UPDATED, 'Updated'

      # @!parse VALID = Valid
      new :VALID, 'Valid'

    end

    # Represents a DataCite `<date/>` field, which can be a year, date (year-month-day or just year-month),
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
    class Date
      include XML::Mapping

      attr_reader :year
      attr_reader :month
      attr_reader :day
      attr_reader :hour
      attr_reader :minute
      attr_reader :sec
      attr_reader :nsec

      # Initializes a new `Date`
      #
      # @param type [DateType] the type of date. Cannot be nil.
      # @param value [DateTime, Date, Integer, String] The value, as a `DateTime`, `Date`, or `Integer`,
      #   or as a `String` in any [W3C DateTime format](http://www.w3.org/TR/NOTE-datetime)
      def initialize(type:, value:)
        self.type = type
        self.value = value
      end

      def type=(val)
        fail ArgumentError, 'Date type cannot be nil' unless val
        @type = val
      end

      # Sets the value.
      #
      # @param val [DateTime, Date, Integer, String] The value, as a `DateTime`, `Date`, or `Integer`,
      #   or as a `String` in any [W3C DateTime format](http://www.w3.org/TR/NOTE-datetime)
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
        @value = new_value
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

      # @!attribute [rw] type
      #  @return [DateType] the type of date. Cannot be nil.
      typesafe_enum_node :type, '@dateType', class: DateType

      # @!method value
      #   @return [String] The value as a string. May be any [W3C DateTime format](http://www.w3.org/TR/NOTE-datetime).
      text_node :value, 'text()'
    end
  end
end
