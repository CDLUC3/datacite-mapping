require 'spec_helper'

module Datacite
  module Mapping
    describe FundingReference do

      describe '#parse_xml' do
        attr_reader :fref_xml
        attr_reader :fref

        before(:all) do
          @fref_xml = '<fundingReference>
                                   <funderName>European Commission</funderName>
                                   <funderIdentifier funderIdentifierType="Open Funder Registry">http://doi.org/10.13039/501100000780</funderIdentifier>
                                   <awardNumber awardURI="http://cordis.europa.eu/project/rcn/100180_en.html">282625</awardNumber>
                                   <awardTitle>MOTivational strength of ecosystem services and alternative ways to express the value of BIOdiversity</awardTitle>
                                 </fundingReference>'.freeze

          @fref = FundingReference.parse_xml(fref_xml)
        end

        it 'parses XML' do
          expect(fref.name).to eq('European Commission')

          id = fref.identifier
          expect(id).to be_a(FunderIdentifier)
          expect(id.type).to eq(FunderIdentifierType::OPEN_FUNDER_REGISTRY)
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
