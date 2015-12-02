require 'xml/mapping_extensions'
require_relative 'geo_location_point'
require_relative 'geo_location_box'

module Datacite
  module Mapping

    class GeoLocation
      include XML::Mapping

      root_element_name 'geoLocation'

      geo_location_point_node :point, 'geoLocationPoint', default_value: nil
      geo_location_box_node :box, 'geoLocationBox', default_value: nil
      text_node :place, 'geoLocationPlace', default_value: nil

      def initialize(point: nil, box: nil, place: nil)
        self.point = point
        self.box = box
        self.place = place
      end

      alias_method :_place=, :place=

      def place=(value)
        self._place = value.respond_to?(:strip) ? value.strip : value
      end

    end
  end
end
