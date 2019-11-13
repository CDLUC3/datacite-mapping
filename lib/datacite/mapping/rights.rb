# frozen_string_literal: true

require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Rights information for the {Resource}
    class Rights
      include XML::Mapping

      # Initializes a new {Rights} object
      #
      # @param uri [URI, nil] a URI for the license. Optional.
      # @param identifier [String, nil] Optional.
      # @param identifier_scheme [String, nil] Optional.
      # @param scheme_url [URI, nil] Optional.
      # @param language [String, nil] Optional.
      # @param value [String] a rights statement.
      def initialize(uri: nil, identifier: nil, identifier_scheme: nil, scheme_uri: nil, language: nil, value: nil)
        self.uri = uri
        self.identifier = identifier
        self.identifier_scheme = identifier_scheme
        self.scheme_uri = scheme_uri
        self.language = language
        self.value = value
      end

      def language=(value)
        @language = value&.strip
      end

      def value=(new_value)
        @value = new_value&.strip
      end

      # @!attribute [rw] uri
      #   @return [URI, nil] a URI for the license. Optional.
      uri_node :uri, '@rightsURI', default_value: nil

      # @!attribute [rw] language
      #   @return [String, nil] an IETF BCP 47, ISO 639-1 language code identifying the language.
      text_node :language, '@xml:lang', default_value: nil

      # @!attribute [rw] identifier
      #   @return [String, nil] an identifier for the rights setting. Optional.
      text_node :identifier, '@rightsIdentifier', default_value: nil

      # @!attribute [rw] identifier_scheme
      #   @return [String, nil] an identifier for the rights scheme. Optional.
      text_node :identifier_scheme, '@rightsIdentifierScheme', default_value: nil

      # @!attribute [rw] scheme_uri
      #   @return [URI, nil] a URI for the rights scheme. Optional.
      uri_node :scheme_uri, '@schemeURI', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the rights statement. Cannot be empty or nil.
      text_node :value, 'text()', default_value: nil

      fallback_mapping :datacite_3, :_default
    end

    class Rights
      CC_ZERO = Rights.new(
        uri: URI('https://creativecommons.org/publicdomain/zero/1.0/'),
        value: 'CC0 1.0 Universal (CC0 1.0) Public Domain Dedication'
      )

      CC_BY = Rights.new(
        uri: URI('https://creativecommons.org/licenses/by/4.0/'),
        value: 'Creative Commons Attribution 4.0 International (CC BY 4.0)'
      )
    end

  end
end
