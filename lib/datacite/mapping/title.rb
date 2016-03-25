require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Controlled vocabulary of title types (for titles other than the main/default title).
    class TitleType < TypesafeEnum::Base
      # @!parse ALTERNATIVE_TITLE = AlternativeTitle
      new :ALTERNATIVE_TITLE, 'AlternativeTitle'

      # @!parse SUBTITLE = Subtitle
      new :SUBTITLE, 'Subtitle'

      # @!parse TRANSLATED_TITLE = TranslatedTitle
      new :TRANSLATED_TITLE, 'TranslatedTitle'

    end

    # A name or title by which a {Resource} is known.
    class Title
      include XML::Mapping

      # @!attribute [rw] language
      #   @return [String] an IETF BCP 47, ISO 639-1 language code identifying the language.
      #     It's unclear from the spec whether language is required; to play it safe, if it's missing, we default to 'en'.
      text_node :language, '@xml:lang', default_value: nil

      # @!attribute [rw] type
      #   @return [TitleType, nil] the title type. Optional.
      typesafe_enum_node :type, '@titleType', class: TitleType, default_value: nil

      # @!attribute [rw] value
      #   @return [String] the title itself.
      text_node :value, 'text()'

      maybe_alias :_language, :language
      private :_language

      maybe_alias :_language=, :language=
      private :_language=

      # Initializes a new {Title}.
      # @param language [String] an IETF BCP 47, ISO 639-1 language code identifying the language.
      #   It's unclear from the spec whether language is required; to play it safe, if it's missing, we default to 'en'.
      # @param value [String] the title itself.
      # @param type [TitleType, nil] the title type. Optional.
      def initialize(language: 'en', value:, type: nil)
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

      maybe_alias :_value=, :value=

      def value=(v)
        fail ArgumentError, 'Value cannot be empty or nil' unless v && !v.empty?
        self._value = v.strip
      end
    end
  end
end
