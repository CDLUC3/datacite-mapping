require 'xml/mapping'

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
          return order if order != 0
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
    # TODO: merge shared code with GeoLocationBoxNode
    class GeoLocationPointNode < XML::MappingExtensions::NodeBase

      COORD_ELEMENTS = { latitude: 'pointLatitude',
                         longitude: 'pointLongitude' }

      def extract_attr_value(xml)
        return from_text(xml) || from_children(xml)
      rescue => e
        raise e, "#{@owner}.#{@attrname}: Can't extract #{self.class} from #{xml}: #{e.message}"
      end

      def to_value(xml_text)
        stripped = xml_text.strip
        return if stripped.empty?

        coords = stripped.split(/\s+/).map(&:to_f)
        GeoLocationPoint.new(*coords)
      end

      private

      # Parses Datacite 3.x text coordinates
      def from_text(xml)
        xml_text = default_when_xpath_err { @path.first(xml).text }
        return unless xml_text
        to_value(xml_text)
      end

      # Parses Datacite 4.x child-element coordinates
      def from_children(xml)
        elem = @path.first(xml)
        coords_hash = COORD_ELEMENTS.map do |key, element_name|
          value = elem.elements[element_name].text
          [key, value && value.to_f]
        end.to_h
        GeoLocationPoint.new(coords_hash)
      end
    end
    XML::Mapping.add_node_class GeoLocationPointNode

  end
end
