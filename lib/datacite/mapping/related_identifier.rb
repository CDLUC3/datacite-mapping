require 'xml/mapping_extensions'

module Datacite
  module Mapping

    class RelationType < TypesafeEnum::Base
      new :IS_CITED_BY, 'IsCitedBy'
      new :CITES, 'Cites'
      new :IS_SUPPLEMENT_TO, 'IsSupplementTo'
      new :IS_SUPPLEMENTED_BY, 'IsSupplementedBy'
      new :IS_CONTINUED_BY, 'IsContinuedBy'
      new :CONTINUES, 'Continues'
      new :HAS_METADATA, 'HasMetadata'
      new :IS_METADATA_FOR, 'IsMetadataFor'
      new :IS_NEW_VERSION_OF, 'IsNewVersionOf'
      new :IS_PREVIOUS_VERSION_OF, 'IsPreviousVersionOf'
      new :IS_PART_OF, 'IsPartOf'
      new :HAS_PART, 'HasPart'
      new :IS_REFERENCED_BY, 'IsReferencedBy'
      new :REFERENCES, 'References'
      new :IS_DOCUMENTED_BY, 'IsDocumentedBy'
      new :DOCUMENTS, 'Documents'
      new :IS_COMPILED_BY, 'IsCompiledBy'
      new :COMPILES, 'Compiles'
      new :IS_VARIANT_FORM_OF, 'IsVariantFormOf'
      new :IS_ORIGINAL_FORM_OF, 'IsOriginalFormOf'
      new :IS_IDENTICAL_TO, 'IsIdenticalTo'
      new :IS_REVIEWED_BY, 'IsReviewedBy'
      new :REVIEWS, 'Reviews'
      new :IS_DERIVED_FROM, 'IsDerivedFrom'
      new :IS_SOURCE_OF, 'IsSourceOf'
    end

    class RelatedIdentifier
      include XML::Mapping

      root_element_name 'relatedIdentifier'

      typesafe_enum_node :_relation_type, '@relationType', class: RelationType
      text_node :_value, 'text()'
      text_node :_identifier_type, '@relatedIdentifierType'
      text_node :related_metadata_scheme, '@relatedMetadataScheme', default_value: nil
      uri_node :scheme_uri, '@schemeURI', default_value: nil
      text_node :scheme_type, '@schemeType', default_value: nil

      def initialize(relation_type:, value:, identifier_type:, related_metadata_scheme: nil, scheme_uri: nil, scheme_type: nil) # rubocop:disable Metrics/ParameterLists
        self.relation_type = relation_type
        self.value = value
        self.identifier_type = identifier_type
        self.related_metadata_scheme = related_metadata_scheme
        self.scheme_uri = scheme_uri
        self.scheme_type = scheme_type
      end

      def value
        _value
      end

      def value=(value)
        fail ArgumentError, 'Value cannot be empty or nil' unless value && !value.empty?
        self._value = value
      end

      def identifier_type
        _identifier_type
      end

      def identifier_type=(value)
        fail ArgumentError, 'Identifier type cannot be empty or nil' unless value && !value.empty?
        self._identifier_type = value
      end

      def relation_type
        _relation_type
      end

      def relation_type=(value)
        fail ArgumentError, 'Relation type cannot be nil' unless value
        self._relation_type = value
      end
    end

    # Not to be instantiated directly -- just call `Resource#related_identifiers`
    class RelatedIdentifiers
      include XML::Mapping

      root_element_name 'relatedIdentifiers'

      array_node :related_identifiers, 'relatedIdentifier', class: RelatedIdentifier

      def initialize(related_identifiers:)
        self.related_identifiers = related_identifiers || []
      end
    end
  end
end
