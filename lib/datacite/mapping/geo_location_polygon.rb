require 'xml/mapping'

module Datacite
  module Mapping
    class GeoLocationPolygon
      include XML::Mapping

      # # @!attribute [rw] polygon
      # #   @return [Array<GeoLocationPoint>] an array of points defining the polygon area.
      array_node :points, 'polygonPoint',
                 default_value: [],
                 marshaller: (proc do |xml, value|
                   marshal_point(xml, value)
                 end),
                 unmarshaller: (proc do |xml|
                   unmarshal_point(xml)
                 end)

      # Creates a new `GeoLocationPolygon`.
      #
      # @param points [Array<GeoLocationPoint>] an array of points defining the polygon area.
      #   Per the spec, the array should contain at least four points, the first and last being
      #   identical to close the polygon.
      def initialize(points:) # TODO: allow simple array of point args
        self.points = points
        num_points = points.size
        warn "Polygon should contain at least 4 points, but has #{num_points}" if num_points < 4
        if num_points > 1
          first = points[0]
          last = points[-1]
          warn "Polygon is not closed; last and first point should be identical, but were: [#{first}], [#{last}]" unless first == last
        end
      end

      def points=(value)
        @points = value || []
      end

      # TODO: make this work
      # def to_s
      #   points.map { |p| "(#{p})"}.join(',')
      # end

      # def datacite_3?
      #   mapping == :datacite_3
      # end

      COORD_ELEMENTS = { latitude: 'pointLatitude',
                         longitude: 'pointLongitude' }.freeze

      def self.marshal_point(element, value)
        # TODO: figure out how to run-time check for datacite 3 mapping
        # if datacite_3?
        #   fail "Can't marshal polygons in Datacite 3"
        # else
          COORD_ELEMENTS.each do |getter, element_name|
            child = element.elements << REXML::Element.new(element_name)
            child.text = value.send(getter)
          end
        # end
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
