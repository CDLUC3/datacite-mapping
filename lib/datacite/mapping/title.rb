require 'xml/mapping_extensions'

module Datacite
  module Mapping

    class TitleType < TypesafeEnum::Base
      new :ALTERNATIVE_TITLE, 'AlternativeTitle'
      new :SUBTITLE, 'Subtitle'
      new :TRANSLATED_TITLE, 'TranslatedTitle'
    end

    class Title
      include XML::Mapping

      text_node :_lang, '@xml:lang', default_value: nil
      typesafe_enum_node :type, '@titleType', class: TitleType, default_value: nil
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
