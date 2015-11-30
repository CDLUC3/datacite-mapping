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
        fail ArgumentError, 'Language cannot be empty or nil' unless value && !value.empty?
        self._lang = value
      end

      def value
        _value
      end

      def value=(value)
        fail ArgumentError, 'Value cannot be empty or nil' unless value && !value.empty?
        self._value = value
      end
    end
  end
end
