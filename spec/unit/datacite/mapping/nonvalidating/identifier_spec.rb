require 'spec_helper'

module Datacite
  module Mapping
    module Nonvalidating
      describe Identifier do
        describe '#load_from_xml' do
          it 'parses a valid identifier' do
            xml_text = "<identifier identifierType='DOI'>10.14749/1407399498</identifier>"
            id = Identifier.parse_xml(xml_text, mapping: :nonvalidating)
            expect(id.identifier_type).to eq('DOI')
            expect(id.value).to eq('10.14749/1407399498')
          end

          it 'parses an identifier with a missing value' do
            xml_text = "<identifier identifierType='DOI'/>"
            id = Identifier.parse_xml(xml_text, mapping: :nonvalidating)
            expect(id.identifier_type).to eq('DOI')
            expect(id.value).to be_nil
          end
        end

        describe '#save_to_xml' do
          it 'writes a valid identifier' do
            xml_text = "<identifier identifierType='DOI'>10.14749/1407399498</identifier>"
            id = Identifier.parse_xml(xml_text, mapping: :nonvalidating)
            expect(id.write_xml(mapping: :nonvalidating)).to be_xml(xml_text)
          end
          it 'writes an identifier with a missing value' do
            xml_text = "<identifier identifierType='DOI'/>"
            id = Identifier.parse_xml(xml_text, mapping: :nonvalidating)
            expect(id.write_xml(mapping: :nonvalidating)).to be_xml(xml_text)
          end
        end
      end
    end
  end
end
