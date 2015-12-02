require 'xml/mapping'
require_relative 'geo_location_point'
require_relative 'geo_location_box'

module Datacite
  module Mapping

    class GeoLocation
      include XML::Mapping

      # TODO: custom reader/writers
      object_node :point, 'geoLocationPoint', class: GeoLocationPoint, default_value: nil
      object_node :box, 'geoLocationBox', class: GeoLocationBox, default_value: nil
      text_node :place, 'geoLocationPlace', default_value: nil
    end
  end
end
