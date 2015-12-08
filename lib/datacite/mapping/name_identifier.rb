require 'xml/mapping_extensions'

module Datacite
  module Mapping
    # Uniquely identifies an individual or legal entity, according to various schemes.
    class NameIdentifier
      include XML::Mapping

      root_element_name 'nameIdentifier'

      # @!attribute [rw] scheme
      #   @return [String] the name identifier scheme. Cannot be nil.
      text_node :scheme, '@nameIdentifierScheme'
      # @!attribute [rw] scheme_uri
      #   @return [URI, nil] the URI of the identifier scheme. Optional.
      uri_node :scheme_uri, '@schemeURI', default_value: nil
      # @!attribute [rw] value
      #   @return [String] the identifier value. Cannot be nil.
      text_node :value, 'text()'

      alias_method :_scheme=, :scheme=
      private :_scheme=

      alias_method :_value=, :value=
      private :_value=

      # Initializes a new {NameIdentifier}
      # @param scheme [Scheme] the name identifier scheme. Cannot be nil.
      # @param scheme_uri [URI, nil] the URI of the identifier scheme. Optional.
      # @param value [String] the identifier value. Cannot be nil.
      def initialize(scheme:, scheme_uri: nil, value:)
        self.scheme = scheme
        self.scheme_uri = scheme_uri
        self.value = value
      end

      def scheme=(v)
        fail ArgumentError, 'Scheme cannot be empty or nil' unless v && !v.empty?
        self._scheme = v
      end

      def value=(v)
        fail ArgumentError, 'Value cannot be empty or nil' unless v && !v.empty?
        self._value = v
      end
    end
  end
end
