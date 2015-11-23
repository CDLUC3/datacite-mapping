require 'xml/mapping_extensions'

module Datacite
  module Mapping
    class Date
      include XML::Mapping

      text_node :_value, 'text()'

      def initialize(value:)
        self.value = value
      end

      def value=(val)
        self._value = val
      end

      def value
        self._value
      end
    end
  end
end
