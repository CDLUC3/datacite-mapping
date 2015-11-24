require 'spec_helper'

module Datacite
  module Mapping
    describe ResourceType do
      describe '#initialize' do
        it 'sets the value' do
          rt = ResourceType.new(resource_type_general: ResourceTypeGeneral::DATASET, value: 'some data')
          expect(rt.value).to eq('some data')
        end
        it 'sets the general resource type' do
          rt = ResourceType.new(resource_type_general: ResourceTypeGeneral::DATASET, value: 'some data')
          expect(rt.resource_type_general).to eq(ResourceTypeGeneral::DATASET)
        end
        it 'requires a value' do
          expect { ResourceType.new(resource_type_general: ResourceTypeGeneral::DATASET) }.to raise_error(ArgumentError)
        end
        it 'requires a general resource type' do
          expect { ResourceType.new(value: 'some data') }.to raise_error(ArgumentError)
        end
      end

      describe 'resourceTypeGeneral=' do
        it 'sets the general resource type' do
          rt = ResourceType.allocate
          rt.resource_type_general = ResourceTypeGeneral::DATASET
          expect(rt.resource_type_general).to eq(ResourceTypeGeneral::DATASET)
        end
        it 'requires a general resource type' do
          rt = ResourceType.new(resource_type_general: ResourceTypeGeneral::DATASET, value: 'some data')
          expect { rt.resource_type_general = nil }.to raise_error(ArgumentError)
          expect(rt.resource_type_general).to eq(ResourceTypeGeneral::DATASET)
        end
      end

      describe 'value' do
        it 'sets the value' do
          rt = ResourceType.allocate
          rt.value = 'some data'
          expect(rt.value).to eq('some data')
        end
        it 'requires a value' do
          rt = ResourceType.new(resource_type_general: ResourceTypeGeneral::DATASET, value: 'some data')
          expect { rt.value = nil }.to raise_error(ArgumentError)
          expect(rt.value).to eq('some data')
        end
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<resourceType resourceTypeGeneral="Software">XML</resourceType>'
          xml = REXML::Document.new(xml_text).root
          rt = ResourceType.load_from_xml(xml)
          expect(rt.resource_type_general).to eq(ResourceTypeGeneral::SOFTWARE)
          expect(rt.value).to eq('XML')
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          rt = ResourceType.new(resource_type_general: ResourceTypeGeneral::DATASET, value: 'some data')
          expected_xml = '<resourceType resourceTypeGeneral="Dataset">some data</resourceType>'
          expect(rt.save_to_xml).to be_xml(expected_xml)
        end
      end
    end
  end
end
