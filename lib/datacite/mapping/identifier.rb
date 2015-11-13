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

    end
  end
end
