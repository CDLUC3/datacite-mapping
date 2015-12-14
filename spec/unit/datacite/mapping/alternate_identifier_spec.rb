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
          id = AlternateIdentifier.parse_xml(xml_text)
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
  end
end
