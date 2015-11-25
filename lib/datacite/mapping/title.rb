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
      text_node :_value, 'text()'

      def initialize(lang:, type: nil, value:)
        self._lang = lang
        self.type = type
        self.value = value
      end

      def lang
        _lang || 'en'
      end

      def lang=(value)
        fail ArgumentError, 'Language cannot be nil' unless value && !value.empty?
        self._lang = value
      end

      def value
        _value
      end

      def value=(value)
        fail ArgumentError, 'Value cannot be nil' unless value && !value.empty?
        self._value = value
      end

    end

    # Not to be instantiated directly -- just call `Resource#titles`
    class Titles
      include XML::Mapping

      array_node :titles, 'title', class: Title

      def initialize(titles:)
        fail ArgumentError, 'No titles provided' unless titles && !titles.empty?
        self.titles = titles
      end
    end
  end
end
