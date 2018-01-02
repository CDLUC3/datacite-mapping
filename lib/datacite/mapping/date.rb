# frozen_string_literal: true

require 'xml/mapping_extensions'

require 'datacite/mapping/date_value'

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
    # ISO8601 datetime, or [RKMS-ISO8601](http://www.ukoln.ac.uk/metadata/dcmi/collection-RKMS-ISO8601/) date range.
    #
    # @!attribute [r] date_value
    #   @return [DateValue, nil] the single date/time represented by this `<date/>` field,
    #     if it does not represent a ragne
    # @!attribute [r] range_start
    #   @return [DateValue, nil] the start of the date range represented by this `<date/> field`,
    #     if it represents a range, and the range is not open on the lower end
    # @!attribute [r] range_end
    #   @return [DateValue, nil] the end of the date range represented by this `<date/> field`,
    #     if it represents a range, and the range is not open on the upper end
    class Date
      include Comparable
      include XML::Mapping

      attr_reader :date_value
      attr_reader :range_start
      attr_reader :range_end

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
        raise ArgumentError, 'Date type cannot be nil' unless val
        @type = val
      end

      def value=(val) # rubocop:disable Metrics/AbcSize
        parts = val.to_s.split('/', -1) # negative limit so we don't drop trailing empty string
        @date_value, @range_start, @range_end = nil
        if parts.size == 1
          @date_value = DateValue.new(val)
        elsif parts.size == 2
          @range_start, @range_end = parts.map(&:strip).map { |part| DateValue.new(part) unless part == '' }
          # puts "#{val} -> [#{range_start}, #{range_end}]"
        else
          raise ArgumentError, "Unable to parse date value #{val}"
        end
        @value = date_value ? date_value.to_s : "#{range_start}/#{range_end}"
      end

      def <=>(other)
        return nil unless other.class == self.class
        %i[date_value range_start range_end type].each do |v|
          order = send(v) <=> other.send(v)
          return order if order.nonzero?
        end
        0
      end

      def hash
        [date_value, range_start, range_end, type].hash
      end

      def to_s
        @value
      end

      # @!attribute [rw] type
      #  @return [DateType] the type of date. Cannot be nil.
      typesafe_enum_node :type, '@dateType', class: DateType

      # @!method value
      #   @return [String] The value as a string. May be any [W3C DateTime format](http://www.w3.org/TR/NOTE-datetime).
      text_node :value, 'text()'

      fallback_mapping :datacite_3, :_default
    end
  end
end
