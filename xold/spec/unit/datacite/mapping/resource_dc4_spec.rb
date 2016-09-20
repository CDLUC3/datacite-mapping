# coding: utf-8
require 'spec_helper'

module Datacite
  module Mapping
    describe Resource do
      describe '#parse_xml' do
        it 'parses all Datacite 4 example documents' do
          Dir.glob('spec/data/datacite4/*xml') do |f|
            begin
              xml_text = File.read(f)
              resource = Resource.parse_xml(xml_text)
              expect(resource).to be_a(Resource)
            rescue => e
              raise e, "#{f} failed with exception: #{e}", e.backtrace
            end
          end
        end
      end
    end
  end
end
