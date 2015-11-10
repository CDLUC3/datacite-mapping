require 'ruby-enum'
require 'xml/mapping_extensions'

module Datacite
  module Mapping
    module Types

      class TitleType
        include Ruby::Enum

        define :ALTERNATIVE_TITLE, 'AlternativeTitle'
        define :SUBTITLE, 'Subtitle'
        define :TRANSLATED_TITLE, 'TranslatedTitle'
      end

      class TitleTypeNode < XML::MappingExtensions::EnumNodeBase
        ENUM_CLASS = TitleType
      end
      XML::Mapping.add_node_class TitleTypeNode

    end
  end
end
