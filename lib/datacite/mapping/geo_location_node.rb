require 'xml/mapping_extensions'

module Datacite
  module Mapping
    # Abstract superclass of GeoLocation parsing nodes
    class GeoLocationNode < XML::Mapping::SingleAttributeNode

      attr_reader :geom_class
      attr_reader :coord_elements

      def initialize(*args)
        fail 'No geometry class provided' unless @geom_class
        fail 'No coordinate elements provided' unless @coord_elements
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      def datacite_3?
        mapping == :datacite_3
      end

      def extract_attr_value(xml)
        return from_text(xml) || from_children(xml)
      rescue => e
        raise e, "#{@owner}.#{@attrname}: Can't extract #{self.class} from #{xml}: #{e.message}"
      end

      def set_attr_value(xml, value) # rubocop:disable Metrics/AbcSize
        fail "Invalid value: expected #{geom_class} instance, was #{value || 'nil'}" unless value && value.is_a?(geom_class)
        element = @path.first(xml, ensure_created: true)

        if datacite_3?
          element.text = value.to_s
        else
          coord_elements.each do |getter, element_name|
            child = element.elements << REXML::Element.new(element_name)
            child.text = value.send(getter)
          end
        end
      end

      private

      # Parses Datacite 3.x text coordinates
      def from_text(xml)
        xml_text = default_when_xpath_err { @path.first(xml).text }
        return unless xml_text

        stripped = xml_text.strip
        return if stripped.empty?

        coords = stripped.split(/\s+/).map(&:to_f)
        geom_class.new(*coords)
      end

      # Parses Datacite 4.x child-element coordinates
      def from_children(xml)
        elem = @path.first(xml)
        coords_hash = coord_elements.map do |key, element_name|
          value = elem.elements[element_name].text
          [key, value && value.to_f]
        end.to_h
        geom_class.new(coords_hash)
      end
    end
  end
end
