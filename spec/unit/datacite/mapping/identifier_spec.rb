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

        it 'requires a non-nil value' do
          expect { Identifier.new(value: nil) }.to raise_error(ArgumentError)
        end

        it 'sets the type' do
          id = Identifier.new(value: '10.14749/1407399495')
          expect(id.identifier_type).to eq('DOI')
        end

        it 'disallows bad DOIs' do
          bad_dois = %w(
            20.14749/1407399495
            11.14749/1407399495
            10./1407399495
            10.14749\1407399495
            10.14749/
          )
          bad_dois.each do |doi|
            expect { Identifier.new(value: doi) }.to raise_error(ArgumentError)
          end
        end

        it 'strips' do
          value = '10.14749/1407399495'
          id = Identifier.new(value: "
            #{value}
          ")
          expect(id.value).to eq(value)
        end

      end

      describe '#from_doi' do
        it 'creates an identifier from a doi: string' do
          doi_value = '10.1594/WDCC/CCSRNIES_SRES_B2'
          doi_string = "doi:#{doi_value}"
          id = Identifier.from_doi(doi_string)
          expect(id).to be_an(Identifier)
          expect(id.value).to eq(doi_value)
          expect(id.identifier_type).to eq('DOI')
        end

        it 'creates an identifier from a plain DOI value' do
          doi_value = '10.1594/WDCC/CCSRNIES_SRES_B2'
          id = Identifier.from_doi(doi_value)
          expect(id).to be_an(Identifier)
          expect(id.value).to eq(doi_value)
          expect(id.identifier_type).to eq('DOI')
        end

        it 'creates an identifier from a DOI in URL format' do
          doi_value = '10.1594/WDCC/CCSRNIES_SRES_B2'
          doi_string = "http://dx.doi.org/#{doi_value}"
          id = Identifier.from_doi(doi_string)
          expect(id).to be_an(Identifier)
          expect(id.value).to eq(doi_value)
          expect(id.identifier_type).to eq('DOI')
        end

        it 'raises ArgumentError if it is passed a bad DOI' do
          bad_dois = %w(
            20.14749/1407399495
            11.14749/1407399495
            10./1407399495
            10.14749\1407399495
            10.14749/
          )
          bad_dois.each do |doi|
            expect { Identifier.from_doi(doi) }.to raise_error do |e|
              expect(e).to be_an(ArgumentError)
              expect(e.message).to include(doi)
            end
          end
        end
      end

      describe '#value=' do
        it 'sets the value' do
          id = Identifier.allocate
          id.value = '10.14749/1407399495'
          expect(id.value).to eq('10.14749/1407399495')
        end
        it 'disallows bad DOIs' do
          id = Identifier.allocate
          bad_dois = %w(
            20.14749/1407399495
            11.14749/1407399495
            10./1407399495
            10.14749\1407399495
            10.14749/
          )
          bad_dois.each do |doi|
            expect { id.value = doi }.to raise_error(ArgumentError)
            expect(id.value).to be_nil
          end
        end
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = "<identifier identifierType='DOI'>10.14749/1407399498</identifier>"
          id = Identifier.parse_xml(xml_text)
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
