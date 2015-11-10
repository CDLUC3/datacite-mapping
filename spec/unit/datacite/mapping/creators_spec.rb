require 'spec_helper'

module Datacite
  module Mapping
    describe Creators do
      it 'round-trips to xml' do
        xml_text = '<creators>
                      <creator>
                        <creatorName>Hedy Lamarr</creatorName>
                        <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                        <affiliation>United Artists</affiliation>
                        <affiliation>Metro-Goldwyn-Mayer</affiliation>
                      </creator>
                      <creator>
                        <creatorName>Hershlag, Natalie</creatorName>
                        <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-0907-8419</nameIdentifier>
                        <affiliation>Gaumont Buena Vista International</affiliation>
                        <affiliation>20th Century Fox</affiliation>
                      </creator>
                    </creators>'
        xml = REXML::Document.new(xml_text).root
        creators = Creators.load_from_xml(xml)
        expect(creators.save_to_xml).to be_xml(xml_text)
      end
    end
  end
end
