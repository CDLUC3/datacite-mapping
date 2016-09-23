require 'xml/mapping'
require 'datacite/mapping/geo_location_node'

module Datacite
  module Mapping
    # A latitude-longitude point at which the data was gathered or about
    # which the data is focused.
    #
    # @!attribute [rw] latitude
    #   @return [Numeric] the latitude
    # @!attribute [rw] longitude
    #   @return [Numeric] the longitude
    class GeoLocationPoint
      include Comparable

      attr_reader :latitude
      attr_reader :longitude

      # Initializes a new {GeoLocationPoint}. The arguments can be provided
      # either as a named-parameter hash, or as a pair of coordinates in the
      # form `lat, long`. That is, the following forms are equivalent:
      #
      #     GeoLocationPoint.new(latitude: 47.61, longitude: -122.33)
      #
      #     GeoLocationPoint.new(47.61, -122.33)
      #
      # @param latitude [Numeric] the latitude
      # @param longitude [Numeric] the longitude
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

      # Gets the coordinates as a string.
      # @return [String] the coordinates as a pair of numbers separated by a space, in the
      #   order `lat` `long`.
      def to_s
        "#{latitude} #{longitude}"
      end

      # Sorts points from north to south and from east to west, and compares them for equality.
      # @param other [GeoLocationPoint] the point to compare
      # @return [Fixnum, nil] the sort order (-1, 0, or 1), or nil if `other` is not a
      #   {GeoLocationPoint}
      def <=>(other)
        return nil unless other.class == self.class
        [:latitude, :longitude].each do |c|
          order = send(c) <=> other.send(c)
          return order if order.nonzero?
        end
        0
      end

      # Returns a hash code consistent with {GeoLocationPoint#&lt;=&gt;}
      # @return [Integer] the hash code
      def hash
        [latitude, longitude].hash
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

    # XML mapping node for `<geoLocationPoint/>`
    class GeoLocationPointNode < GeoLocationNode
      def initialize(*args)
        @geom_class = GeoLocationPoint
        @coord_elements = { latitude: 'pointLatitude',
                            longitude: 'pointLongitude' }.freeze
        super
      end
    end
    XML::Mapping.add_node_class GeoLocationPointNode

  end
end
