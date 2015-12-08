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

      # nil isn't actually allowed, but we generously allow it on reading (converting to 'en')
      text_node :language, '@xml:lang', default_value: nil
      typesafe_enum_node :type, '@titleType', class: TitleType, default_value: nil
      text_node :value, 'text()'

      alias_method :_language, :language
      private :_language

      alias_method :_language=, :language=
      private :_language=

      def initialize(language:, type: nil, value:)
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

      alias_method :_value=, :value=

      def value=(v)
        fail ArgumentError, 'Value cannot be empty or nil' unless v && !v.empty?
        self._value = v.strip
      end
    end
  end
end
