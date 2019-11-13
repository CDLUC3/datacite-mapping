# frozen_string_literal: true

require 'xml/mapping'
require 'datacite/mapping/read_only_nodes'

module Datacite
  module Mapping
    class Affiliation
      include XML::Mapping

      def initialize(identifier: nil, identifier_scheme: nil, scheme_uri: nil, value:)
        self.identifier = identifier
        self.identifier_scheme = identifier_scheme
        self.scheme_uri = scheme_uri
        self.value = value
      end

      def value=(value)
        new_value = value&.strip
        raise ArgumentError, 'Value cannot be empty or nil' unless new_value && !new_value.empty?

        @value = new_value.strip
      end

      # @!attribute [rw] identifier
      #   @return [String, nil] The affiliation identifier. Optional.
      text_node :identifier, '@affiliationIdentifier', default_value: nil

      # @!attribute [rw] identifier_scheme
      #   @return [String, nil] The scheme for the affiliation identifier. Optional.
      text_node :identifier_scheme, '@affiliationIdentifierScheme', default_value: nil

      # @!attribute [rw] scheme_uri
      #   @return [URI, nil] the URI of the identifier scheme. Optional.
      uri_node :scheme_uri, '@schemeURI', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the name itself.
      text_node :value, 'text()'

      fallback_mapping :datacite_3, :_default
    end
  end
end
