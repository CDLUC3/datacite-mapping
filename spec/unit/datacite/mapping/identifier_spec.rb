require 'spec_helper'

module Datacite
  module Mapping
    describe Identifier do

      describe '#initialize' do
        it 'sets the value' do
          value = '10.14749/1407399495'
          id = Identifier.new(value: value)
          expect(id.value).to eq(value)
        end

        it 'sets the type' do
          id = Identifier.new(value: '10.14749/1407399495')
          expect(id.identifier_type).to eq('DOI')
        end

        it 'disallows bad DOIs'
      end

      describe '#value=' do
        it 'sets the value'
        it 'disallows bad DOIs'
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = "<identifier identifierType='DOI'>10.14749/1407399498</identifier>"
          xml = REXML::Document.new(xml_text).root
          id = Identifier.load_from_xml(xml)
          expect(id.identifier_type).to eq('DOI')
          expect(id.value).to eq('10.14749/1407399498')
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          id = Identifier.new(value: '10.14749/1407399498')
          xml = id.save_to_xml
          expect(xml).to be_xml("<identifier identifierType='DOI'>10.14749/1407399498</identifier>")
        end
      end

    end
  end
end
