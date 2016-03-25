require 'xml/mapping_extensions'
require_relative 'geo_location_point'
require_relative 'geo_location_box'

module Datacite
  module Mapping

    # A location at which the data was gathered or about which the data is focused, in the
    # form of a latitude-longitude point, a latitude-longitude quadrangle, and/or a place name.
    #
    # *Note:* Due to a quirk of the DataCite spec, it is possible for a {GeoLocation} to be empty, with
    # none of these present.
    class GeoLocation
      include XML::Mapping

      root_element_name 'geoLocation'

      # @!attribute [rw] point
      #   @return [GeoLocationPoint, nil] the latitude and longitude at which the data was gathered or about which the data is focused.
      geo_location_point_node :point, 'geoLocationPoint', default_value: nil

      # @!attribute [rw] box
      #   @return [GeoLocationBox, nil] the latitude-longitude quadrangle containing the area where the data was gathered or about which the data is focused.
      geo_location_box_node :box, 'geoLocationBox', default_value: nil

      # @!attribute [rw] place
      #   @return [String, nil] the spatial region or named place where the data was gathered or about which the data is focused.
      text_node :place, 'geoLocationPlace', default_value: nil

      # Initializes a new {GeoLocation}
      # @param point [GeoLocationPoint, nil] the latitude and longitude at which the data was gathered or about which the data is focused.
      # @param box [GeoLocationBox, nil] the latitude-longitude quadrangle containing the area where the data was gathered or about which the data is focused.
      # @param place [String, nil] the spatial region or named place where the data was gathered or about which the data is focused.
      def initialize(point: nil, box: nil, place: nil)
        self.point = point
        self.box = box
        self.place = place
      end

      maybe_alias :_place=, :place=
      private :_place=

      def place=(value)
        self._place = value.respond_to?(:strip) ? value.strip : value
      end

    end
  end
end
