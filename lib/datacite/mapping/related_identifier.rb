require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Controlled list of relationships of the {Resource} to a related resource.
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

    # Controlled list of related identifier types.
    class RelatedIdentifierType < TypesafeEnum::Base
      new :ARK, 'ARK'
      new :ARXIV, 'arXiv'
      new :BIBCODE, 'bibcode'
      new :DOI, 'DOI'
      new :EAN13, 'EAN13'
      new :EISSN, 'EISSN'
      new :HANDLE, 'Handle'
      new :ISBN, 'ISBN'
      new :ISSN, 'ISSN'
      new :ISTC, 'ISTC'
      new :LISSN, 'LISSN'
      new :LSID, 'LSID'
      new :PMID, 'PMID'
      new :PURL, 'PURL'
      new :UPC, 'UPC'
      new :URL, 'URL'
      new :URN, 'URN'
    end

    # Globally unique identifier of a related resource.
    class RelatedIdentifier
      include XML::Mapping

      root_element_name 'relatedIdentifier'

      # @!attribute [rw] relation_type
      #   @return [RelationType] the relationship of the {Resource} to the related resource. Cannot be nil.
      typesafe_enum_node :relation_type, '@relationType', class: RelationType

      # @!attribute [rw] value
      #   @return [String] the identifier value. Cannot be nil.
      text_node :value, 'text()'

      # @!attribute [rw] identifier_type
      #   @return [RelatedIdentifierType] the type of the related identifier. Cannot be nil.
      typesafe_enum_node :identifier_type, '@relatedIdentifierType', class: RelatedIdentifierType

      # @!attribute [rw] related_metadata_scheme
      #   @return [String, nil] the name of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      text_node :related_metadata_scheme, '@relatedMetadataScheme', default_value: nil

      # @!attribute [rw] scheme_uri
      #   @return [URI, nil] the URI of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      uri_node :scheme_uri, '@schemeURI', default_value: nil

      # @!attribute [rw] scheme_type
      #   @return [String, nil] the type of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      text_node :scheme_type, '@schemeType', default_value: nil

      alias_method :_relation_type=, :relation_type=
      private :_relation_type=
      alias_method :_value=, :value=
      private :_value=
      alias_method :_identifier_type=, :identifier_type=
      private :_identifier_type=

      # Initializes a new {RelatedIdentifier}.
      # @param relation_type [RelationType] the relationship of the {Resource} to the related resource. Cannot be nil.
      # @param value [String] the identifier value. Cannot be nil.
      # @param identifier_type [RelatedIdentifierType] the type of the related identifier. Cannot be nil.
      # @param related_metadata_scheme [String, nil] the name of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      # @param scheme_uri [URI, nil] the URI of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      # @param scheme_type [String, nil] the type of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      def initialize(relation_type:, value:, identifier_type:, related_metadata_scheme: nil, scheme_uri: nil, scheme_type: nil) # rubocop:disable Metrics/ParameterLists
        self.relation_type = relation_type
        self.value = value
        self.identifier_type = identifier_type
        self.related_metadata_scheme = related_metadata_scheme
        self.scheme_uri = scheme_uri
        self.scheme_type = scheme_type
      end

      def value=(value)
        fail ArgumentError, 'Value cannot be empty or nil' unless value && !value.empty?
        self._value = value
      end

      def identifier_type=(value)
        fail ArgumentError, 'Identifier type cannot be empty or nil' unless value
        self._identifier_type = value
      end

      def relation_type=(value)
        fail ArgumentError, 'Relation type cannot be nil' unless value
        self._relation_type = value
      end
    end
  end
end
