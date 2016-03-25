require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Rights information for the {Resource}
    class Rights
      include XML::Mapping

      # @!attribute [rw] uri
      #   @return [URI, nil] a URI for the license. Optional.
      uri_node :uri, '@rightsURI', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the rights statement. Cannot be empty or nil.
      text_node :value, 'text()'

      # Initializes a new {Rights} object
      #
      # @param uri [URI, nil] a URI for the license. Optional.
      # @param value [String] the rights statement. Cannot be empty or nil.
      def initialize(uri: nil, value:)
        self.uri = uri
        self.value = value
      end

      maybe_alias :_value=, :value=
      private :_value=

      def value=(v)
        fail ArgumentError, 'Value cannot be empty or nil' unless v && !v.empty?
        self._value = v.strip
      end
    end
  end
end
