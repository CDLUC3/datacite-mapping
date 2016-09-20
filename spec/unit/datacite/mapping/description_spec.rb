require 'spec_helper'

module Datacite
  module Mapping
    describe Description do

      describe '#load_from_xml' do
        it 'reads XML' do
          xml_text = '<description xml:lang="en-us" descriptionType="Abstract">
                        XML example of all DataCite Metadata Schema v3.1 properties.
                      </description>'
          desc = Description.parse_xml(xml_text)

          expected_lang = 'en-us'
          expected_type = DescriptionType::ABSTRACT
          expected_value = 'XML example of all DataCite Metadata Schema v3.1 properties.'

          expect(desc.language).to eq(expected_lang)
          expect(desc.type).to eq(expected_type)
          expect(desc.value).to eq(expected_value)
        end

        it 'handles escaped HTML' do
          xml_text = '<description xml:lang="en-us" descriptionType="Abstract">
                        &lt;p&gt;This is HTML text&lt;/p&gt;&lt;p&gt;&lt;small&gt;despite the advice in the standard&lt;/small&gt;&lt;/p&gt;
                      </description>'
          desc = Description.parse_xml(xml_text)

          expected_value = '<p>This is HTML text</p><p><small>despite the advice in the standard</small></p>'
          expect(desc.value).to eq(expected_value)
        end

        it 'strips extra whitespace' do
          xml_text = '<description xml:lang="en-us" descriptionType="Abstract">
                        This is the value
                      </description>'
          desc = Description.parse_xml(xml_text)
          expect(desc.value).to eq('This is the value')
        end

        it 'allows un-escaped <br/> and <br></br> tags' do
          xml_text = '<description descriptionType="Abstract">
                        I am an <br></br> abstract <br/> full <br/> of &lt;br/&gt;s
                      </description>'
          desc = Description.parse_xml(xml_text)
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
          expected_xml = '<description xml:lang="en" descriptionType="Abstract">&lt;p&gt;This is HTML text&lt;/p&gt;</description>'
          expect(desc.save_to_xml).to be_xml(expected_xml)
        end
        it 'preserves <br/> and <br></br> tags' do
          desc = Description.new(type: DescriptionType::ABSTRACT, value: '<br/> &lt;br/&gt; abstract <br></br> full <br /> of <br> </br>s')
          expected_xml = '<description xml:lang="en" descriptionType="Abstract"><br/> &amp;lt;br/&amp;gt; abstract <br/> full <br/> of <br/>s</description>'
          expect(desc.save_to_xml).to be_xml(expected_xml)
        end
      end

      it 'round-trips to XML' do
        xml_text = '<description xml:lang="en-us" descriptionType="Abstract">foo</description>'
        desc = Description.parse_xml(xml_text)
        expect(desc.save_to_xml).to be_xml(xml_text)
      end

      it 'un-escapes <br/> tags when round-tripping' do
        xml_text = '<description xml:lang="en-us" descriptionType="Abstract"><br/> &lt;br/&gt; abstract <br></br> full <br /> of <br> </br>s</description>'
        desc = Description.parse_xml(xml_text)
        expected_xml = '<description xml:lang="en-us" descriptionType="Abstract"><br/> <br/> abstract <br></br> full <br /> of <br> </br>s</description>'
        expect(desc.save_to_xml).to be_xml(expected_xml)

      end
    end
  end
end
