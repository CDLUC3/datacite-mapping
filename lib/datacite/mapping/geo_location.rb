require 'xml/mapping_extensions'
require 'datacite/mapping/geo_location_point'
require 'datacite/mapping/geo_location_box'

module Datacite
  module Mapping

    # A location at which the data was gathered or about which the data is focused, in the
    # form of a latitude-longitude point, a latitude-longitude quadrangle, and/or a place name.
    #
    # *Note:* Due to a quirk of the DataCite spec, it is possible for a {GeoLocation} to be empty, with
    # none of these present.
    class GeoLocation
      include XML::Mapping

      # Initializes a new {GeoLocation}
      # @param point [GeoLocationPoint, nil] the latitude and longitude at which the data was gathered or about which the data is focused.
      # @param box [GeoLocationBox, nil] the latitude-longitude quadrangle containing the area where the data was gathered or about which the data is focused.
      # @param place [String, nil] the spatial region or named place where the data was gathered or about which the data is focused.
      # @param polygon [GeoLocationPolygon, nil] a drawn polygon area containing the area where the data was gathered or about which the data is focused.
      def initialize(point: nil, box: nil, place: nil, polygon: nil)
        self.point = point
        self.box = box
        self.place = place
        self.polygon = polygon
      end

      def place=(value)
        @place = value.respond_to?(:strip) ? value.strip : value
      end

      def location?
        point || box || place || polygon
      end

      root_element_name 'geoLocation'

      # @!attribute [rw] place
      #   @return [String, nil] the spatial region or named place where the data was gathered or about which the data is focused.
      text_node :place, 'geoLocationPlace', default_value: nil

      # @!attribute [rw] point
      #   @return [GeoLocationPoint, nil] the latitude and longitude at which the data was gathered or about which the data is focused.
      geo_location_point_node :point, 'geoLocationPoint', default_value: nil

      # @!attribute [rw] box
      #   @return [GeoLocationBox, nil] the latitude-longitude quadrangle containing the area where the data was gathered or about which the data is focused.
      geo_location_box_node :box, 'geoLocationBox', default_value: nil

      # # @!attribute [rw] polygon
      # #   @return [GeoLocationPolygon] a drawn polygon area containing the area where the data was gathered or about which the data is focused.
      object_node :polygon, 'geoLocationPolygon', default_value: nil

      use_mapping :datacite_3

      read_only_array_node :polygon, 'geoLocationPolygon', class: GeoLocationPoint, default_value: []

      fallback_mapping :datacite_3, :_default
    end
  end
end
