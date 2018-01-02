# frozen_string_literal: true

require 'xml/mapping'

module Datacite
  module Mapping
    class GeoLocationPolygon
      include Comparable
      include XML::Mapping

      # Creates a new `GeoLocationPolygon`.
      #
      # @param points [Array<GeoLocationPoint>] an array of points defining the polygon area.
      #   Per the spec, the array should contain at least four points, the first and last being
      #   identical to close the polygon.
      def initialize(points:) # TODO: allow simple array of point args, array of hashes
        self.points = points
        warn "Polygon should contain at least 4 points, but has #{points.size}" if points.size < 4
        warn "Polygon is not closed; last and first point should be identical, but were: [#{points[0]}], [#{points[-1]}]" unless points[0] == points[-1] || points.size <= 1
      end

      def points=(value)
        @points = value || []
      end

      def <=>(other)
        return nil unless other.class == self.class
        points <=> other.points
      end

      def hash
        points.hash
      end

      def to_s
        point_hashes = points.map { |p| "{ latitude: #{p.latitude}, longitude: #{p.longitude} }" }.join(', ')
        "[ #{point_hashes} ]"
      end

      # # @!attribute [rw] polygon
      # #   @return [Array<GeoLocationPoint>] an array of points defining the polygon area.
      array_node :points, 'polygonPoint',
                 default_value: [],
                 marshaller: (proc { |xml, value| marshal_point(xml, value) }),
                 unmarshaller: (proc { |xml| unmarshal_point(xml) })

      use_mapping :datacite_3

      # TODO: does this ever get called?
      read_only_array_node :points, 'polygonPoint', class: GeoLocationPoint, default_value: [], warn_reason: 'not available in Datacite 3'

      fallback_mapping :datacite_3, :_default

      # TODO: Figure out how to DRY this with GeoLocationPointNode

      COORD_ELEMENTS = { longitude: 'pointLongitude',
                         latitude: 'pointLatitude' }.freeze

      def self.marshal_point(element, value)
        COORD_ELEMENTS.each do |getter, element_name|
          v = value.send(getter)
          child = element.elements << REXML::Element.new(element_name)
          child.text = v
        end
      end

      def self.unmarshal_point(elem)
        coords_hash = COORD_ELEMENTS.map do |key, element_name|
          value = elem.elements[element_name].text
          [key, value && value.to_f]
        end.to_h
        GeoLocationPoint.new(coords_hash)
      end

    end
  end
end
