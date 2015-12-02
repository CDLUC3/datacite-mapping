require 'xml/mapping_extensions'
require_relative 'geo_location_point'
require_relative 'geo_location_box'

module Datacite
  module Mapping

    class GeoLocation
      include XML::Mapping

      geo_location_point_node :point, 'geoLocationPoint', default_value: nil
      geo_location_box_node :box, 'geoLocationBox', default_value: nil
      text_node :place, 'geoLocationPlace', default_value: nil
    end
  end
end
