# frozen_string_literal: true

require 'xml/mapping_extensions'
require 'datacite/mapping/resource_type'

module Datacite
  module Mapping

    # Controlled list of relationships of the {Resource} to a related resource.
    class RelationType < TypesafeEnum::Base
      # @!parse IS_CITED_BY = IsCitedBy
      new :IS_CITED_BY, 'IsCitedBy'

      # @!parse CITES = Cites
      new :CITES, 'Cites'

      # @!parse IS_SUPPLEMENT_TO = IsSupplementTo
      new :IS_SUPPLEMENT_TO, 'IsSupplementTo'

      # @!parse IS_SUPPLEMENTED_BY = IsSupplementedBy
      new :IS_SUPPLEMENTED_BY, 'IsSupplementedBy'

      # @!parse IS_CONTINUED_BY = IsContinuedBy
      new :IS_CONTINUED_BY, 'IsContinuedBy'

      # @!parse CONTINUES = Continues
      new :CONTINUES, 'Continues'

      # @!parse HAS_METADATA = HasMetadata
      new :HAS_METADATA, 'HasMetadata'

      # @!parse IS_METADATA_FOR = IsMetadataFor
      new :IS_METADATA_FOR, 'IsMetadataFor'

      # @!parse IS_NEW_VERSION_OF = IsNewVersionOf
      new :IS_NEW_VERSION_OF, 'IsNewVersionOf'

      # @!parse IS_PREVIOUS_VERSION_OF = IsPreviousVersionOf
      new :IS_PREVIOUS_VERSION_OF, 'IsPreviousVersionOf'

      # @!parse HAS_VERSION = HasVersion
      new :HAS_VERSION, 'HasVersion'

      # @!parse IS_VERSION_OF = IsVersionOf
      new :IS_VERSION_OF, 'IsVersionOf'

      # @!parse IS_PART_OF = IsPartOf
      new :IS_PART_OF, 'IsPartOf'

      # @!parse HAS_PART = HasPart
      new :HAS_PART, 'HasPart'

      # @!parse IS_REFERENCED_BY = IsReferencedBy
      new :IS_REFERENCED_BY, 'IsReferencedBy'

      # @!parse REFERENCES = References
      new :REFERENCES, 'References'

      # @!parse IS_DOCUMENTED_BY = IsDocumentedBy
      new :IS_DOCUMENTED_BY, 'IsDocumentedBy'

      # @!parse DOCUMENTS = Documents
      new :DOCUMENTS, 'Documents'

      # @!parse IS_COMPILED_BY = IsCompiledBy
      new :IS_COMPILED_BY, 'IsCompiledBy'

      # @!parse COMPILES = Compiles
      new :COMPILES, 'Compiles'

      # @!parse IS_VARIANT_FORM_OF = IsVariantFormOf
      new :IS_VARIANT_FORM_OF, 'IsVariantFormOf'

      # @!parse IS_ORIGINAL_FORM_OF = IsOriginalFormOf
      new :IS_ORIGINAL_FORM_OF, 'IsOriginalFormOf'

      # @!parse IS_IDENTICAL_TO = IsIdenticalTo
      new :IS_IDENTICAL_TO, 'IsIdenticalTo'

      # @!parse IS_REVIEWED_BY = IsReviewedBy
      new :IS_REVIEWED_BY, 'IsReviewedBy'

      # @!parse REVIEWS = Reviews
      new :REVIEWS, 'Reviews'

      # @!parse IS_DERIVED_FROM = IsDerivedFrom
      new :IS_DERIVED_FROM, 'IsDerivedFrom'

      # @!parse IS_SOURCE_OF = IsSourceOf
      new :IS_SOURCE_OF, 'IsSourceOf'

      # @!parse IS_OBSOLETED_BY = IsObsoletedBy
      new :IS_OBSOLETED_BY, 'IsObsoletedBy'

      # @!parse OBSOLETES = Obsoletes
      new :OBSOLETES, 'Obsoletes'

      # @!parse IS_DESCRIBED_BY = IsDescribedBy
      new :IS_DESCRIBED_BY, 'IsDescribedBy'

      # @!parse DESCRIBES = Describes
      new :DESCRIBES, 'Describes'

      # @!parse IS_REQUIRED_BY = IsRequiredBy
      new :IS_REQUIRED_BY, 'IsRequiredBy'

      # @!parse REQUIRES = Requires
      new :REQUIRES, 'Requires'

    end

    # Controlled list of related identifier types.
    class RelatedIdentifierType < TypesafeEnum::Base
      # @!parse ARK = ARK
      new :ARK, 'ARK'

      # @!parse ARXIV = arXiv
      new :ARXIV, 'arXiv'

      # @!parse BIBCODE = bibcode
      new :BIBCODE, 'bibcode'

      # @!parse DOI = DOI
      new :DOI, 'DOI'

      # @!parse EAN13 = EAN13
      new :EAN13, 'EAN13'

      # @!parse EISSN = EISSN
      new :EISSN, 'EISSN'

      # @!parse HANDLE = Handle
      new :HANDLE, 'Handle'

      # @!parse ISBN = ISBN
      new :ISBN, 'ISBN'

      # @!parse ISSN = ISSN
      new :ISSN, 'ISSN'

      # @!parse ISTC = ISTC
      new :ISTC, 'ISTC'

      # @!parse LISSN = LISSN
      new :LISSN, 'LISSN'

      # @!parse LSID = LSID
      new :LSID, 'LSID'

      # @!parse PMID = PMID
      new :PMID, 'PMID'

      # @!parse PURL = PURL
      new :PURL, 'PURL'

      # @!parse UPC = UPC
      new :UPC, 'UPC'

      # @!parse URL = URL
      new :URL, 'URL'

      # @!parse URN = URN
      new :URN, 'URN'

      # @!parse IGSN = IGSN
      new :IGSN, 'IGSN'

      # @!parse W3ID = w3id
      new :W3ID, 'w3id'
    end

    class Datacite3RidTypeNode < XML::MappingExtensions::TypesafeEnumNode
      def to_xml_text(enum_instance)
        return super unless enum_instance == RelatedIdentifierType::IGSN

        super(RelatedIdentifierType::HANDLE)
      end
    end
    XML::Mapping.add_node_class(Datacite3RidTypeNode)

    class Datacite3RidValueNode < XML::Mapping::TextNode
      def obj_to_xml(obj, xml)
        return super unless obj.identifier_type == RelatedIdentifierType::IGSN

        igsn_value = obj.value
        handle_value = "10273/#{igsn_value}"
        # TODO: move this somewhere more general
        ReadOnlyNodes.warn("IGSN identifiers not directly supported in Datacite 3; converting IGSN #{igsn_value} to Handle #{handle_value}")
        set_attr_value(xml, handle_value)
        true
      end
    end
    XML::Mapping.add_node_class(Datacite3RidValueNode)

    # Globally unique identifier of a related resource.
    class RelatedIdentifier
      include XML::Mapping

      # Initializes a new {RelatedIdentifier}.
      # @param relation_type [RelationType] the relationship of the {Resource} to the related resource. Cannot be nil.
      # @param value [String] the identifier value. Cannot be nil.
      # @param identifier_type [RelatedIdentifierType] the type of the related identifier. Cannot be nil.
      # @param related_metadata_scheme [String, nil] the name of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      # @param scheme_uri [URI, nil] the URI of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      # @param scheme_type [String, nil] the type of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      def initialize(relation_type:, value:, identifier_type:, related_metadata_scheme: nil, scheme_uri: nil, scheme_type: nil)
        self.relation_type = relation_type
        self.value = value
        self.identifier_type = identifier_type
        self.related_metadata_scheme = related_metadata_scheme
        self.scheme_uri = scheme_uri
        self.scheme_type = scheme_type
      end

      def value=(value)
        raise ArgumentError, 'Value cannot be empty or nil' unless value && !value.empty?

        @value = value
      end

      def identifier_type=(value)
        raise ArgumentError, 'Identifier type cannot be empty or nil' unless value

        @identifier_type = value
      end

      def relation_type=(value)
        raise ArgumentError, 'Relation type cannot be nil' unless value

        @relation_type = value
      end

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

      # @!attribute [rw] resource_type_general
      #    @return [ResourceTypeGeneral] the general resource type
      typesafe_enum_node :resource_type_general, '@resourceTypeGeneral', class: ResourceTypeGeneral, default_value: nil

      # @!attribute [rw] scheme_uri
      #   @return [URI, nil] the URI of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      uri_node :scheme_uri, '@schemeURI', default_value: nil

      # @!attribute [rw] scheme_type
      #   @return [String, nil] the type of the metadata scheme. Used only with `HasMetadata`/`IsMetadataFor`. Optional.
      text_node :scheme_type, '@schemeType', default_value: nil

      use_mapping :datacite_3
      datacite3_rid_type_node :identifier_type, '@relatedIdentifierType', class: RelatedIdentifierType
      datacite3_rid_value_node :value, 'text()'

      fallback_mapping :datacite_3, :_default
    end
  end
end
