require 'xml/mapping'

module Datacite
  module Mapping
    class GeoLocationPoint
      attr_reader :latitude
      attr_reader :longitude

      def initialize(*args)
        case args.length
        when 1
          init_from_hash(args[0])
        when 2
          init_from_array(args)
        else
          fail ArgumentError, "Can't construct GeoLocationPoint from arguments: #{args}"
        end
      end

      def latitude=(value)
        fail ArgumentError, 'Latitude cannot be nil' unless value
        fail ArgumentError, "#{value} is not a valid latitude" unless value >= -90 && value <= 90
        @latitude = value
      end

      def longitude=(value)
        fail ArgumentError, 'Longitude cannot be nil' unless value
        fail ArgumentError, "#{value} is not a valid longitude" unless value >= -180 && value <= 180
        @longitude = value
      end

      private

      def init_from_hash(latitude:, longitude:)
        self.latitude = latitude
        self.longitude = longitude
      end

      def init_from_array(args)
        self.latitude, self.longitude = args
      end
    end
  end
end
