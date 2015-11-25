require 'spec_helper'

module Datacite
  module Mapping
    describe RelatedIdentifier do
      describe '#initialize' do
        it 'sets the relatedIdentifierType' do
          ri = RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001')
          expect(ri.identifier_type).to eq('arXiv')
        end
        it 'sets the relationType' do
          ri = RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001')
          expect(ri.relation_type).to eq(RelationType::IS_REVIEWED_BY)
        end
        it 'sets the relatedMetadataScheme' do
          ri = RelatedIdentifier.new(related_metadata_scheme: 'citeproc+json', identifier_type: 'URL', relation_type: RelationType::HAS_METADATA, value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full')
          expect(ri.related_metadata_scheme).to eq('citeproc+json')
        end
        it 'sets the schemeURI' do
          ri = RelatedIdentifier.new(scheme_uri: URI('https://github.com/citation-style-language/schema/raw/master/csl-data.json'), identifier_type: 'URL', relation_type: RelationType::HAS_METADATA, value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full')
          expect(ri.scheme_uri).to eq(URI('https://github.com/citation-style-language/schema/raw/master/csl-data.json'))
        end
        it 'sets the schemeType' do
          ri = RelatedIdentifier.new(scheme_type: 'Turtle', identifier_type: 'URL', relation_type: RelationType::HAS_METADATA, value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full')
          expect(ri.scheme_type).to eq('Turtle')
        end
        it 'sets the value' do
          ri = RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001')
          expect(ri.value).to eq('arXiv:0706.0001')
        end
        it 'requires a relatedIdentifierType' do
          expect { RelatedIdentifier.new(irelation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001') }.to raise_error(ArgumentError)
        end
        it 'requires a relationType' do
          expect { RelatedIdentifier.new(identifier_type: 'arXiv', value: 'arXiv:0706.0001') }.to raise_error(ArgumentError)
        end
        it 'requires a value' do
          expect { RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY) }.to raise_error(ArgumentError)
        end
      end

      describe 'value=' do
        it 'sets the value'
        it 'requires a value'
      end
      describe 'identifier_type=' do
        it 'sets the relatedIdentifierType'
        it 'requires a relatedIdentifierType'
      end
      describe 'relation_type=' do
        it 'sets the relationType'
        it 'requires a relationType'
      end
      describe 'related_metadata_scheme=' do
        it 'sets the relatedMetadataScheme'
        it 'allows a nil relatedMetadataScheme'
      end
      describe 'scheme_uri=' do
        it 'sets the schemeURI'
        it 'allows a nil schemeURI'
      end
      describe 'scheme_type=' do
        it 'sets the schemeType'
        it 'allows a nil schemeType'
      end
    end

    describe RelatedIdentifiers do

    end
  end
end
