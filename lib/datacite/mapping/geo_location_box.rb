# frozen_string_literal: true

require 'xml/mapping'
require 'datacite/mapping/geo_location_node'

module Datacite
  module Mapping
    # A latitude-longitude quadrangle containing the area where the data was gathered or about
    # which the data is focused.
    #
    # @!attribute [rw] south_latitude
    #   @return [Numeric] the latitude of the south edge of the box
    # @!attribute [rw] west_longitude
    #   @return [Numeric] the longitude of the west edge of the box
    # @!attribute [rw] north_latitude
    #   @return [Numeric] the latitude of the north edge of the box
    # @!attribute [rw] east_longitude
    #   @return [Numeric] the longitude of the east edge of the box
    class GeoLocationBox
      include Comparable

      attr_reader :south_latitude
      attr_reader :west_longitude
      attr_reader :north_latitude
      attr_reader :east_longitude

      # Initializes a new {GeoLocationBox}. The arguments can be provided
      # either as a named-parameter hash, or as a list of four coordinates
      # in the form `lat, long, lat, long` (typically
      # `south_latitude, west_longitude, north_latitude, east_longitude`
      # but not necessarily; north/south and east/west will be flipped if
      # need be). That is, the following forms are equivalent:
      #
      #     GeoLocationBox.new(
      #       south_latitude: -33.45,
      #       west_longitude: -122.33,
      #       north_latitude: 47.61,
      #       east_longitude: -70.67
      #     )
      #
      #     GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
      #
      # @param south_latitude [Numeric]
      #   the latitude of the south edge of the box
      # @param west_longitude [Numeric]
      #   the longitude of the west edge of the box
      # @param north_latitude [Numeric]
      #   the latitude of the north edge of the box
      # @param east_longitude [Numeric]
      #   the longitude of the east edge of the box
      def initialize(*args)
        case args.length
        when 1
          if (args[0].respond_to?(:keys))
            init_from_hash(**args[0])
          else
            raise ArgumentError, "Can't construct GeoLocationBox from arguments: #{args}"
          end
        when 4
          init_from_array(args)
        else
          raise ArgumentError, "Can't construct GeoLocationBox from arguments: #{args}"
        end
      end

      def south_latitude=(value)
        raise ArgumentError, 'South latitude cannot be nil' unless value
        raise ArgumentError, "#{value} is not a valid south latitude" unless value >= -90 && value <= 90

        @south_latitude = value
      end

      def west_longitude=(value)
        raise ArgumentError, 'West longitude cannot be nil' unless value
        raise ArgumentError, "#{value} is not a valid west longitude" unless value >= -180 && value <= 180

        @west_longitude = value
      end

      def north_latitude=(value)
        raise ArgumentError, 'North latitude cannot be nil' unless value
        raise ArgumentError, "#{value} is not a valid north latitude" unless value >= -90 && value <= 90

        @north_latitude = value
      end

      def east_longitude=(value)
        raise ArgumentError, 'East longitude cannot be nil' unless value
        raise ArgumentError, "#{value} is not a valid east longitude" unless value >= -180 && value <= 180

        @east_longitude = value
      end

      # Gets the box coordinates as a string.
      # @return [String] the coordinates of the box as a sequence of four numbers, in the order S W N E.
      def to_s
        "#{south_latitude} #{west_longitude} #{north_latitude} #{east_longitude}"
      end

      # Sorts boxes from north to south and east to west, first by south edge, then west
      # edge, then north edge, then east edge, and compares them for equality.
      # @param other [GeoLocationBox] the box to compare
      # @return [Fixnum, nil] the sort order (-1, 0, or 1), or nil if `other` is not a
      #   {GeoLocationBox}
      def <=>(other)
        return nil unless other.class == self.class

        %i[south_latitude west_longitude north_latitude east_longitude].each do |c|
          order = send(c) <=> other.send(c)
          return order if order.nonzero?
        end
        0
      end

      # Returns a hash code consistent with {GeoLocationBox#&lt;=&gt;}
      # @return [Integer] the hash code
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
        self.south_latitude = coordinates[0]
        self.north_latitude = coordinates[2]
        self.west_longitude = coordinates[1]
        self.east_longitude = coordinates[3]
      end
    end

    # XML mapping node for `<geoLocationBox/>`
    class GeoLocationBoxNode < GeoLocationNode
      def initialize(*args)
        @geom_class = GeoLocationBox
        @coord_elements = { west_longitude: 'westBoundLongitude',
                            east_longitude: 'eastBoundLongitude',
                            south_latitude: 'southBoundLatitude',
                            north_latitude: 'northBoundLatitude' }.freeze
        super
      end
    end
    XML::Mapping.add_node_class GeoLocationBoxNode

  end
end
