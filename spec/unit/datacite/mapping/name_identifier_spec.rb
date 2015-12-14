require 'spec_helper'

module Datacite
  module Mapping
    describe NameIdentifier do

      describe '#initialize' do
        it 'sets the identifier scheme and value' do
          id = NameIdentifier.new(scheme: 'ORCID', value: '0000-0003-1632-8708')
          expect(id.scheme).to eq('ORCID')
          expect(id.value).to eq('0000-0003-1632-8708')
        end

        it 'accepts a scheme URI' do
          id = NameIdentifier.new(scheme: 'ORCID', scheme_uri: URI('http://orcid.org/'), value: '0000-0003-1632-8708')
          expect(id.scheme_uri).to eq(URI('http://orcid.org/'))
        end

        it 'defaults to a nil scheme URI' do
          id = NameIdentifier.new(scheme: 'ORCID', value: '0000-0003-1632-8708')
          expect(id.scheme_uri).to be_nil
        end

        it 'requires a scheme' do
          expect { NameIdentifier.new(value: '0000-0003-1632-8708') }.to raise_error(ArgumentError)
        end

        it 'requires a non-empty scheme' do
          expect { NameIdentifier.new(scheme: '', value: '0000-0003-1632-8708') }.to raise_error(ArgumentError)
        end

        it 'requires a value' do
          expect { NameIdentifier.new(scheme: 'ORCID') }.to raise_error(ArgumentError)
        end

        it 'requires a non-empty value' do
          expect { NameIdentifier.new(scheme: '', scheme: 'ORCID') }.to raise_error(ArgumentError)
        end
      end

      describe '#scheme=' do
        it 'requires a scheme' do
          id = NameIdentifier.new(scheme: 'ORCID', value: '0000-0003-1632-8708')
          expect { id.scheme = nil }.to raise_error(ArgumentError)
          expect(id.scheme).to eq('ORCID')
        end

        it 'requires a non-empty scheme' do
          id = NameIdentifier.new(scheme: 'ORCID', value: '0000-0003-1632-8708')
          expect { id.scheme = '' }.to raise_error(ArgumentError)
          expect(id.scheme).to eq('ORCID')
        end
      end

      describe '#value=' do
        it 'requires a value' do
          id = NameIdentifier.new(scheme: 'ORCID', value: '0000-0003-1632-8708')
          expect { id.value = nil }.to raise_error(ArgumentError)
          expect(id.value).to eq('0000-0003-1632-8708')
        end

        it 'requires a non-empty value' do
          id = NameIdentifier.new(scheme: 'ORCID', value: '0000-0003-1632-8708')
          expect { id.value = '' }.to raise_error(ArgumentError)
          expect(id.value).to eq('0000-0003-1632-8708')
        end
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<nameIdentifier schemeURI="http://orcid.org/" nameIdentifierScheme="ORCID">0000-0003-1632-8708</nameIdentifier>'
          id = NameIdentifier.parse_xml(xml_text)
          expect(id.scheme).to eq('ORCID')
          expect(id.scheme_uri).to eq(URI('http://orcid.org/'))
          expect(id.value).to eq('0000-0003-1632-8708')
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          id = NameIdentifier.new(scheme: 'ORCID', scheme_uri: URI('http://orcid.org/'), value: '0000-0003-1632-8708')
          xml = id.save_to_xml
          expect(xml).to be_xml('<nameIdentifier schemeURI="http://orcid.org/" nameIdentifierScheme="ORCID">0000-0003-1632-8708</nameIdentifier>')
        end
      end
    end
  end
end
