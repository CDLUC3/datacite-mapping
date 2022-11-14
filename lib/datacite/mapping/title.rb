# frozen_string_literal: true

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

      # Initializes a new {Title}.
      # @param language [String, nil] an IETF BCP 47, ISO 639-1 language code identifying the language.
      # @param value [String] the title itself.
      # @param type [TitleType, nil] the title type. Optional.
      def initialize(value:, language: nil, type: nil)
        self.language = language
        self.type = type
        self.value = value
      end

      def language=(value)
        @language = value&.strip
      end

      def value=(value)
        new_value = value&.strip
        raise ArgumentError, 'Value cannot be empty or nil' unless new_value && !new_value.empty?

        @value = new_value.strip
      end

      # @!attribute [rw] language
      #   @return [String] an IETF BCP 47, ISO 639-1 language code identifying the language.
      text_node :language, '@xml:lang', default_value: nil

      # @!attribute [rw] type
      #   @return [TitleType, nil] the title type. Optional.
      typesafe_enum_node :type, '@titleType', class: TitleType, default_value: nil

      # @!attribute [rw] value
      #   @return [String] the title itself.
      text_node :value, 'text()'

      fallback_mapping :datacite_3, :_default
    end
  end
end
