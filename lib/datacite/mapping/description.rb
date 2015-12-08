require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Controlled vocabulary of description types.
    class DescriptionType < TypesafeEnum::Base
      new :ABSTRACT, 'Abstract'
      new :METHODS, 'Methods'
      new :SERIES_INFORMATION, 'SeriesInformation'
      new :TABLE_OF_CONTENTS, 'TableOfContents'
      new :OTHER, 'Other'
    end

    # XML mapping class preserving `<br/>` tags in description values
    class BreakPreservingValueNode < XML::Mapping::SingleAttributeNode
      # Collapses a sequence of text nodes and `<br/>` tags into a single string value.
      # Implements `SingleAttributeNode#xml_to_obj`.
      def xml_to_obj(obj, xml)
        value_str = xml.children.map { |c| c.respond_to?(:value) ? c.value : c.to_s }.join
        obj.value = value_str.strip
      end

      # Converts a string value to a sequence of text nodes and `<br/>` tags.
      # Implements `SingleAttributeNode#obj_to_xml`.
      def obj_to_xml(obj, xml)
        value_str = obj.value || ''
        values = value_str.split(%r{<br[^/]?/>|<br>[^<]*</br>})
        values.each_with_index do |v, i|
          xml.add_text(v)
          xml.add_element('br') unless i + 1 >= values.size
        end
      end
    end
    XML::Mapping.add_node_class BreakPreservingValueNode

    # A additional information that does not fit in the other more specific {Resource}
    # attributes.
    #
    # Note: In accordance with the DataCite spec, description text can be separated by
    # HTML `<br/>` tags. The {Description} class will preserve these, but at the expense
    # of converting escaped `<br/>` in text values to actual `<br/>` tags. For example,
    # when reading the following tag:
    #
    #     <description xml:lang="en-us" descriptionType="Abstract">
    #       Line 1<br/>Line 2 containing escaped &lt;br/&gt; tag<br/>Line 3
    #     </description>
    #
    # the value will be returned as the string
    #
    #     "Line 1<br/>Line 2 containing escaped <br/> tag<br/>Line 3"
    #
    # in which it is impossible to distinguish the escaped an un-escaped `<br/>`s. The
    # value would thus be written back to XML as:
    #
    #     <description xml:lang="en-us" descriptionType="Abstract">
    #       Line 1<br/>Line 2 containing escaped <br/> tag<br/>Line 3
    #     </description>
    #
    # Other escaped HTML or XML tags will still be escaped when written back, and other
    # un-escaped HTML and XML tags are of course not allowed.
    class Description
      include XML::Mapping

      # @!attribute [rw] language
      #   @return [String, nil] an IETF BCP 47, ISO 639-1 language code identifying the language. Optional.
      text_node :language, '@xml:lang', default_value: nil

      # @!attribute [rw] type
      #   @return [DescriptionType] the description type.
      typesafe_enum_node :type, '@descriptionType', class: DescriptionType

      # @!attribute [rw] value
      #   @return [String] the description itself.
      break_preserving_value_node :value, 'node()'

      alias_method :_language, :language
      private :_language

      alias_method :_language=, :language=
      private :_language=

      # Initializes a new {Description}
      # @param language [String, nil] an IETF BCP 47, ISO 639-1 language code identifying the language. Optional.
      # @param type [DescriptionType] the description type.
      # @param value [String] the description itself.
      def initialize(language: nil, type:, value:)
        self.language = language
        self.type = type
        self.value = value
      end

      def language
        _language || 'en'
      end

      def language=(value)
        self._language = value.strip if value
      end

    end
  end
end
