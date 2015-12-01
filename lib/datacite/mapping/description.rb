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

    # Note: Contra the DataCite 3.1 spec, `Description` will escape `<br/>` tags
    class Description
      include XML::Mapping

      text_node :language, '@xml:lang', default_value: nil
      typesafe_enum_node :type, '@descriptionType', class: DescriptionType
      text_node :value, 'text()'

      def initialize(language: nil, type:, value:)
        self.language = language
        self.type = type
        self.value = value
      end
    end
  end
end
