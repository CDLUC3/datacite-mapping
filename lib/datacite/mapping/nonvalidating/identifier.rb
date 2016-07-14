require 'xml/mapping'

module Datacite
  module Mapping
    module Nonvalidating

      # The persistent identifier that identifies the resource.
      #
      # @!attribute [r] identifier_type
      #   @return [String] the identifier type (always 'DOI')
      # @!attribute [rw] value
      #   @return [String] the identifier value. Must be a valid DOI value (`10.`_registrant code_`/`_suffix_)
      class Identifier
        include XML::Mapping

        DOI = 'DOI'.freeze

        use_mapping :nonvalidating

        text_node :identifier_type, '@identifierType'
        text_node :value, 'text()', default_value: nil

        fallback_mapping(:_default, :nonvalidating)

        # Initializes a new {Identifier}
        # @param value [String]
        #   the identifier value. Must be a valid DOI value (`10.`_registrant code_`/`_suffix_)
        def initialize(value:)
          self.identifier_type = DOI
          self.value = value
        end

        # Gets the identifiery type.
        def identifier_type
          @identifier_type ||= DOI
        end
      end
    end
  end
end
