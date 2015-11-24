require 'spec_helper'

module Datacite
  module Mapping
    describe AlternateIdentifier do

      describe '#initialize' do
        it 'sets the identifier type and value' do
          id = AlternateIdentifier.new(type: 'URL', value: 'http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml')
          expect(id.type).to eq('URL')
          expect(id.value).to eq('http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml')
        end
      end

      describe 'type' do
        it 'sets the type' do
          rt = AlternateIdentifier.allocate
          rt.type = 'URL'
          expect(rt.type).to eq('URL')
        end
        it 'requires a type' do
          rt = AlternateIdentifier.new(type: 'URL', value: 'http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml')
          expect { rt.type = nil }.to raise_error(ArgumentError)
          expect(rt.type).to eq('URL')
        end
      end

      describe 'value' do
        it 'sets the value' do
          rt = AlternateIdentifier.allocate
          rt.value = 'http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml'
          expect(rt.value).to eq('http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml')
        end
        it 'requires a value' do
          rt = AlternateIdentifier.new(type: 'URL', value: 'http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml')
          expect { rt.value = nil }.to raise_error(ArgumentError)
          expect(rt.value).to eq('http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml')
        end
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<alternateIdentifier alternateIdentifierType="URL">http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml</alternateIdentifier>'
          xml = REXML::Document.new(xml_text).root
          id = AlternateIdentifier.load_from_xml(xml)
          expect(id.type).to eq('URL')
          expect(id.value).to eq('http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml')
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          id = AlternateIdentifier.new(type: 'URL', value: 'http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml')
          expected_xml = '<alternateIdentifier alternateIdentifierType="URL">http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml</alternateIdentifier>'
          expect(id.save_to_xml).to be_xml(expected_xml)
        end
      end
    end

    describe AlternateIdentifiers do
      describe '#initialize' do
        it 'accepts a list of alternate identifiers' do
          id1 = AlternateIdentifier.new(type: 'URL', value: 'http://example.org')
          id2 = AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
          expect(AlternateIdentifiers.new(alternate_identifiers: [id1, id2]).alternate_identifiers).to eq([id1, id2])
        end
        it 'allows an empty list' do
          expect(AlternateIdentifiers.new(alternate_identifiers: []).alternate_identifiers).to eq([])
        end
      end

      describe '#alternate_identifiers' do
        it 'takes a list of alternate identifiers' do
          ids = AlternateIdentifiers.allocate
          id1 = AlternateIdentifier.new(type: 'URL', value: 'http://example.org')
          id2 = AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
          ids.alternate_identifiers = [id1, id2]
          expect(ids.alternate_identifiers).to eq([id1, id2])
        end
      end

      it 'round-trips to xml' do
        xml_text = '  <alternateIdentifiers>
                          <alternateIdentifier alternateIdentifierType="URL">http://schema.datacite.org/schema/meta/kernel-3.1/example/datacite-example-full-v3.1.xml</alternateIdentifier>
                          <alternateIdentifier alternateIdentifierType="arXiv">arXiv:0706.0001</alternateIdentifier>
                        </alternateIdentifiers>'
        xml = REXML::Document.new(xml_text).root
        ids = AlternateIdentifiers.load_from_xml(xml)
        expect(ids.save_to_xml).to be_xml(xml)
      end
    end

  end
end
