require 'xml/mapping_extensions'

module Datacite
  module Mapping

    class DescriptionType < TypesafeEnum::Base
      new :ABSTRACT, 'Abstract'
      new :METHODS, 'Methods'
      new :SERIES_INFORMATION, 'SeriesInformation'
      new :TABLE_OF_CONTENTS, 'TableOfContents'
      new :OTHER, 'Other'
    end

    # Note: Contra the DataCite 3.1 spec, `Description` will escape `<br/>` tags on writing.
    # It will, however, accept un-escaped `<br/>` tags in the description text, including
    # those with both opening and closing tags (`<br></br>`).
    class Description
      include XML::Mapping

      def self.read_value(obj, xml, _default_reader)
        obj.value = xml.children.map { |c| c.respond_to?(:value) ? c.value : c.to_s }.join
      end
      private_class_method :read_value

      text_node :language, '@xml:lang', default_value: nil
      typesafe_enum_node :type, '@descriptionType', class: DescriptionType
      text_node :value, 'text()', reader: Description.method(:read_value).to_proc

      def initialize(language: nil, type:, value:)
        self.language = language
        self.type = type
        self.value = value
      end

    end
  end
end
