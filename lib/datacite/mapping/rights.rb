require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Rights information for the {Resource}
    class Rights
      include XML::Mapping

      # Initializes a new {Rights} object
      #
      # @param uri [URI, nil] a URI for the license. Optional.
      # @param value [String] the rights statement. Cannot be empty or nil.
      def initialize(uri: nil, value:)
        self.uri = uri
        self.value = value
      end

      def value=(v)
        fail ArgumentError, 'Value cannot be empty or nil' unless v && !v.empty?
        @value = v.strip
      end

      # @!attribute [rw] uri
      #   @return [URI, nil] a URI for the license. Optional.
      uri_node :uri, '@rightsURI', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the rights statement. Cannot be empty or nil.
      text_node :value, 'text()'
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
