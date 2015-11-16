require 'xml/mapping'

module Datacite
  module Mapping

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

    class Title
      include XML::Mapping

      text_node :_lang, '@xml:lang', default_value: nil
      title_type_node :type, '@titleType', default_value: nil
      text_node :value, 'text()'

      def initialize(lang:, type: nil, value:)
        self._lang = lang
        self.type = type
        self.value = value
      end

      def lang
        _lang || 'en'
      end

      def lang=(value)
        fail ArgumentError, 'Language cannot be nil' unless value
        self._lang = value
      end

    end

    # Not to be instantiated directly -- just call `Resource#titles`
    class Titles
      include XML::Mapping

      array_node :titles, 'title', class: Title

      def initialize(titles:)
        self.titles = titles
      end
    end
  end
end
