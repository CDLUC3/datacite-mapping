require 'xml/mapping'

module Datacite
  module Mapping

    class GeoLocationPoint
      include XML::Mapping

      # TODO: custom node? custom reader/writer?
      text_node :_value, 'text()'

      attr_reader :latitude
      attr_reader :longitude

      def initialize(*args)
        case args
        when Hash
          init_from_hash(args)
        when Array
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

    class GeoLocationBox
      include XML::Mapping

      # TODO: custom node? custom reader/writer?
      text_node :_value, 'text()'

      attr_reader :south_latitude
      attr_reader :west_longitude
      attr_reader :north_latitude
      attr_reader :east_longitude

      def initialize(*args)
        case args
        when Hash
          init_from_hash(args)
        when Array
          init_from_array(args)
        else
          fail ArgumentError, "Can't construct GeoLocationBox from arguments: #{args}"
        end
      end

      def south_latitude=(value)
        fail ArgumentError, 'South latitude cannot be nil' unless value
        fail ArgumentError, "#{value} is not a valid south latitude" unless value >= -90 && value <= 90
        @south_latitude = value
      end

      def west_longitude=(value)
        fail ArgumentError, 'West longitude cannot be nil' unless value
        fail ArgumentError, "#{value} is not a valid west longitude" unless value >= -180 && value <= 180
        @west_longitude = value
      end

      def north_latitude=(value)
        fail ArgumentError, 'North latitude cannot be nil' unless value
        fail ArgumentError, "#{value} is not a valid north latitude" unless value >= -90 && value <= 90
        @north_latitude = value
      end

      def east_longitude=(value)
        fail ArgumentError, 'East longitude cannot be nil' unless value
        fail ArgumentError, "#{value} is not a valid east longitude" unless value >= -180 && value <= 180
        @east_longitude = value
      end

      private

      def init_from_hash(south_latitude:, west_longitude:, north_latitude:, east_longitude:)
        self.south_latitude = south_latitude
        self.west_longitude = west_longitude
        self.north_latitude = north_latitude
        self.east_longitude = east_longitude
      end

      def init_from_array(coordinates)
        self.south_latitude, self.west_longitude, self.north_latitude, self.east_longitude = coordinates
      end

    end

    class GeoLocation
      include XML::Mapping

      object_node :point, 'geoLocationPoint', class: GeoLocationPoint, default_value: nil
      object_node :box, 'geoLocationBox', class: GeoLocationBox, default_value: nil
      text_node :place, 'geoLocationPlace', default_value: nil
    end
  end
end
