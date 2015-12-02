require 'xml/mapping'

module Datacite
  module Mapping
    class GeoLocationBox
      include Comparable

      attr_reader :south_latitude
      attr_reader :west_longitude
      attr_reader :north_latitude
      attr_reader :east_longitude

      def initialize(*args)
        case args.length
        when 1
          init_from_hash(args[0])
        when 4
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

      def to_s
        "#{south_latitude} #{west_longitude} #{north_latitude} #{east_longitude}"
      end

      def <=>(other)
        return nil unless other.class == self.class
        [:south_latitude, :west_longitude, :north_latitude, :east_longitude].each do |c|
          order = send(c) <=> other.send(c)
          return order if order != 0
        end
        0
      end

      def hash
        [south_latitude, west_longitude, north_latitude, east_longitude].hash
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

    class GeoLocationBoxNode < XML::MappingExtensions::NodeBase
      def to_value(xml_text)
        stripped = xml_text.strip
        coords = stripped.split(/\s+/).map(&:to_f)
        GeoLocationBox.new(*coords)
      end
    end
    XML::Mapping.add_node_class GeoLocationBoxNode

  end
end
