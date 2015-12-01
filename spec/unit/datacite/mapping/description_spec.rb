require 'spec_helper'

module Datacite
  module Mapping
    describe Description do
      describe '#load_from_xml' do
        it 'reads XML' do
          xml_text = '<description xml:lang="en-us" descriptionType="Abstract">
                        XML example of all DataCite Metadata Schema v3.1 properties.
                      </description>'
          xml = REXML::Document.new(xml_text).root
          desc = Description.load_from_xml(xml)

          expected_lang = 'en-us'
          expected_type = DescriptionType::ABSTRACT
          expected_value = 'XML example of all DataCite Metadata Schema v3.1 properties.'

          expect(desc.language).to eq(expected_lang)
          expect(desc.type).to eq(expected_type)
          expect(desc.value.strip).to eq(expected_value)
        end

        it 'handles escaped HTML' do
          xml_text = '<description xml:lang="en-us" descriptionType="Abstract">
                        &lt;p&gt;This is HTML text&lt;/p&gt;&lt;p&gt;&lt;small&gt;despite the advice in the standard&lt;/small&gt;&lt;/p&gt;
                      </description>'
          xml = REXML::Document.new(xml_text).root
          desc = Description.load_from_xml(xml)

          expected_value = '<p>This is HTML text</p><p><small>despite the advice in the standard</small></p>'
          expect(desc.value.strip).to eq(expected_value)
        end

        it 'allows un-escaped <br/> and <br></br> tags' do
          xml_text = '<description descriptionType="Abstract">
                        I am an <br></br> abstract <br/> full <br/> of &lt;br/&gt;s
                      </description>'
          xml = REXML::Document.new(xml_text).root
          desc = Description.load_from_xml(xml)
          expected_value = 'I am an <br/> abstract <br/> full <br/> of <br/>s'
          expect(desc.value.strip).to eq(expected_value)
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          desc = Description.new(language: 'en-us', type: DescriptionType::ABSTRACT, value: 'foo')
          expected_xml = '<description xml:lang="en-us" descriptionType="Abstract">foo</description>'
          expect(desc.save_to_xml).to be_xml(expected_xml)
        end
        it 'escapes HTML' do
          desc = Description.new(type: DescriptionType::ABSTRACT, value: '<p>This is HTML text</p>')
          expected_xml = '<description descriptionType="Abstract">&lt;p&gt;This is HTML text&lt;/p&gt;</description>'
          expect(desc.save_to_xml).to be_xml(expected_xml)
        end
        it 'escapes <br/> and <br></br> tags' do
          desc = Description.new(type: DescriptionType::ABSTRACT, value: 'abstract <br></br> full <br/> of <br/>s')
          expected_xml = '<description descriptionType="Abstract">abstract &lt;br&gt;&lt;/br&gt; full &lt;br/&gt; of &lt;br/&gt;s</description>'
          expect(desc.save_to_xml).to be_xml(expected_xml)
        end
      end
    end
  end
end
