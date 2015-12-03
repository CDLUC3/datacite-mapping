require 'xml/mapping'

module Datacite
  module Mapping
    class Identifier
      include XML::Mapping

      text_node :identifier_type, '@identifierType'
      text_node :value, 'text()'

      def initialize(value:)
        self.identifier_type = 'DOI'
        self.value = value
      end

      alias_method :_value=, :value=

      def value=(v)
        fail ArgumentError, "Identifier value '#{v}' is not a valid DOI" unless v.match(%r{10\..+/.+})
        self._value = v
      end
    end
  end
end
