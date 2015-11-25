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
          expect { RelatedIdentifier.new(relation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001') }.to raise_error(ArgumentError)
        end
        it 'requires a relationType' do
          expect { RelatedIdentifier.new(identifier_type: 'arXiv', value: 'arXiv:0706.0001') }.to raise_error(ArgumentError)
        end
        it 'requires a value' do
          expect { RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY) }.to raise_error(ArgumentError)
        end
      end

      describe 'value=' do
        it 'sets the value' do
          ri = RelatedIdentifier.allocate
          ri.value = 'arXiv:0706.0001'
          expect(ri.value).to eq('arXiv:0706.0001')
        end
        it 'requires a value' do
          ri = RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001')
          expect { ri.value = nil }.to raise_error(ArgumentError)
          expect(ri.value).to eq('arXiv:0706.0001')
        end
        it 'requires a non-empty value' do
          ri = RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001')
          expect { ri.value = '' }.to raise_error(ArgumentError)
          expect(ri.value).to eq('arXiv:0706.0001')
        end
      end
      describe 'identifier_type=' do
        it 'sets the relatedIdentifierType' do
          ri = RelatedIdentifier.allocate
          ri.identifier_type = 'arXiv'
          expect(ri.identifier_type).to eq('arXiv')
        end
        it 'requires a relatedIdentifierType' do
          ri = RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001')
          expect { ri.identifier_type = nil }.to raise_error(ArgumentError)
          expect(ri.identifier_type).to eq('arXiv')
        end
        it 'requires a non-empty relatedIdentifierType' do
          ri = RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001')
          expect { ri.identifier_type = '' }.to raise_error(ArgumentError)
          expect(ri.identifier_type).to eq('arXiv')
        end
      end
      describe 'relation_type=' do
        it 'sets the relationType' do
          ri = RelatedIdentifier.allocate
          ri.relation_type = RelationType::IS_REVIEWED_BY
          expect(ri.relation_type).to eq(RelationType::IS_REVIEWED_BY)
        end
        it 'requires a relationType' do
          ri = RelatedIdentifier.new(identifier_type: 'arXiv', relation_type: RelationType::IS_REVIEWED_BY, value: 'arXiv:0706.0001')
          expect { ri.relation_type = nil }.to raise_error(ArgumentError)
          expect(ri.relation_type).to eq(RelationType::IS_REVIEWED_BY)
        end
      end
      describe 'related_metadata_scheme=' do
        it 'sets the relatedMetadataScheme' do
          ri = RelatedIdentifier.allocate
          ri.related_metadata_scheme = 'citeproc+json'
          expect(ri.related_metadata_scheme).to eq('citeproc+json')
        end
        it 'allows a nil relatedMetadataScheme' do
          ri = RelatedIdentifier.new(related_metadata_scheme: 'citeproc+json', identifier_type: 'URL', relation_type: RelationType::HAS_METADATA, value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full')
          ri.related_metadata_scheme = nil
          expect(ri.related_metadata_scheme).to be_nil
        end
      end
      describe 'scheme_uri=' do
        it 'sets the schemeURI' do
          ri = RelatedIdentifier.allocate
          ri.scheme_uri =  URI('https://github.com/citation-style-language/schema/raw/master/csl-data.json')
          expect(ri.scheme_uri).to eq(URI('https://github.com/citation-style-language/schema/raw/master/csl-data.json'))
        end
        it 'allows a nil schemeURI' do
          ri = RelatedIdentifier.new(scheme_uri: URI('https://github.com/citation-style-language/schema/raw/master/csl-data.json'), identifier_type: 'URL', relation_type: RelationType::HAS_METADATA, value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full')
          ri.scheme_uri = nil
          expect(ri.scheme_uri).to be_nil
        end
      end
      describe 'scheme_type=' do
        it 'sets the schemeType' do
          ri = RelatedIdentifier.allocate
          ri.scheme_type = 'Turtle'
          expect(ri.scheme_type).to eq('Turtle')
        end
        it 'allows a nil schemeType' do
          ri = RelatedIdentifier.new(scheme_type: 'Turtle', identifier_type: 'URL', relation_type: RelationType::HAS_METADATA, value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full')
          ri.scheme_type = nil
          expect(ri.scheme_type).to be_nil
        end
      end

      describe '#load_from_xml' do
        it 'parses XML'
      end

      describe '#save_to_xml' do
        it 'writes XML'
      end
    end

    describe RelatedIdentifiers do
      describe '#initialize' do
        it 'accepts a list of ids'
        it 'allows an empty list'
        it 'round-trips to XML'
      end
    end
  end
end
