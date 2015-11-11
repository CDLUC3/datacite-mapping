require 'spec_helper'

module Datacite
  module Mapping
    describe Titles do
      it 'round-trips to xml' do
        xml_text = '<titles>
                      <title xml:lang="en-us">Full DataCite XML Example</title>
                      <title xml:lang="en-us" titleType="Subtitle">Demonstration of DataCite Properties.</title>
                    </titles>'
        xml = REXML::Document.new(xml_text).root
        titles = Titles.load_from_xml(xml)
        expect(titles.save_to_xml).to be_xml(xml)
      end
    end
  end
end
