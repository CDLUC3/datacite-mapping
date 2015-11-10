require 'xml/mapping_extensions'

module Datacite
  module Mapping
    class NameIdentifier
      include ::XML::Mapping

      root_element_name 'nameIdentifier'

      text_node :scheme, '@nameIdentifierScheme'
      uri_node :scheme_uri, '@schemeURI', default: nil
      text_node :value, 'text()'

      def initialize(scheme:, scheme_uri: nil, value:)
        self.scheme = scheme
        self.scheme_uri = scheme_uri
        self.value = value
      end
    end
  end
end
