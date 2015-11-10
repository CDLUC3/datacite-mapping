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
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<nameIdentifier schemeURI="http://orcid.org/" nameIdentifierScheme="ORCID">0000-0003-1632-8708</nameIdentifier>'
          xml = REXML::Document.new(xml_text).root
          id = NameIdentifier.load_from_xml(xml)
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
