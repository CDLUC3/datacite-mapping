require 'spec_helper'

module Datacite
  module Mapping

    describe FunderIdentifier do
      describe '#new' do
        it 'requires a non-nil type' do
          expect do
            FunderIdentifier.new(type: nil, value: 'http://doi.org/10.13039/501100000780')
          end.to raise_error(ArgumentError)
        end

        it 'requires a non-nil value' do
          expect do
            FunderIdentifier.new(type: FunderIdentifierType::CROSSREF_FUNDER_ID, value: nil)
          end.to raise_error(ArgumentError)
        end
      end
    end

    describe FundingReference do

      describe '#initialize' do
        it 'accepts an AwardNumber object' do
          award_number = AwardNumber.new(value: '9 3/4')
          fref = FundingReference.new(name: 'Ministry of Magic', award_number: award_number)
          expect(fref.award_number).to be(award_number)
        end

        it 'accepts a text award_number' do
          fref = FundingReference.new(name: 'Ministry of Magic', award_number: '9 3/4')
          award_number = fref.award_number
          expect(award_number).to be_an(AwardNumber)
          expect(award_number.value).to eq('9 3/4')
        end
      end

      describe '#parse_xml' do
        attr_reader :fref_xml
        attr_reader :fref

        before(:all) do
          @fref_xml = '<fundingReference>
                         <funderName>European Commission</funderName>
                         <funderIdentifier funderIdentifierType="Crossref Funder ID">http://doi.org/10.13039/501100000780</funderIdentifier>
                         <awardNumber awardURI="http://cordis.europa.eu/project/rcn/100180_en.html">282625</awardNumber>
                         <awardTitle>MOTivational strength of ecosystem services and alternative ways to express the value of BIOdiversity</awardTitle>
                       </fundingReference>'.freeze

          @fref = FundingReference.parse_xml(fref_xml)
        end

        it 'parses XML' do
          expect(fref.name).to eq('European Commission')

          id = fref.identifier
          expect(id).to be_a(FunderIdentifier)
          expect(id.type).to eq(FunderIdentifierType::CROSSREF_FUNDER_ID)
          expect(id.value).to eq('http://doi.org/10.13039/501100000780')

          award_number = fref.award_number
          expect(award_number).to be_an(AwardNumber)
          expect(award_number.value).to eq('282625')
          expect(award_number.uri).to eq(URI('http://cordis.europa.eu/project/rcn/100180_en.html'))

          expect(fref.award_title).to eq('MOTivational strength of ecosystem services and alternative ways to express the value of BIOdiversity')
        end

        it 'round-trips' do
          xml = fref.write_xml
          expect(xml).to be_xml(fref_xml)
        end
      end

    end
  end
end
