require 'spec_helper'

module Datacite
  module Mapping
    describe Title do
      describe '#initialize' do
        it 'sets the value' do
          value = 'An Account of a Very Odd Monstrous Calf'
          title = Title.new(value: value, lang: 'en-emodeng')
          expect(title.value).to eq(value)
        end

        it 'sets the language' do
          lang = 'en-emodeng'
          title = Title.new(lang: lang, value: 'Observables upon a Monstrous Head', lang: 'en-emodeng')
          expect(title.lang).to eq(lang)
        end

        it 'requires a language' do
          expect { Title.new(value: 'A Relation of an Accident by Thunder and Lightning, at Oxford') }.to raise_error(ArgumentError)
        end

        it 'sets the type' do
          type = Types::TitleType::SUBTITLE
          title = Title.new(type: type, value: 'And a Contest between Two Artists about Optick Glasses, &c', lang: 'en-emodeng')
          expect(title.type).to eq(type)
        end

        it 'defaults to a nil type' do
          title = Title.new(value: "Of Some Books Lately Publish't", lang: 'en-emodeng')
          expect(title.type).to be_nil
        end
      end

      describe 'lang=' do
        it 'sets the language' do
          title = Title.new(value: "Of Some Books Lately Publish't", lang: 'en-emodeng')
          new_lang = 'en-gb'
          title.lang = new_lang
          expect(title.lang).to eq(new_lang)
        end
        it 'requires a language' do
          title = Title.new(value: "Of Some Books Lately Publish't", lang: 'en-emodeng')
          expect { title.lang = nil }.to raise_error(ArgumentError)
        end
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<title xml:lang="en-emodeng" titleType="Subtitle">Together with an Appendix of the Same, Containing an Answer to Some Objections, Made by Severall Persons against That Hypothesis</title>'
          xml = REXML::Document.new(xml_text).root
          title = Title.load_from_xml(xml)

          expected_lang = 'en-emodeng'
          expected_type = Types::TitleType::SUBTITLE
          expected_value = 'Together with an Appendix of the Same, Containing an Answer to Some Objections, Made by Severall Persons against That Hypothesis'

          expect(title.lang).to eq(expected_lang)
          expect(title.type).to eq(expected_type)
          expect(title.value).to eq(expected_value)
        end

        it 'treats missing language as en' do
          xml_text = '<title>Physical oceanography from BT during cruise U99XX00542B_1979</title>'
          xml = REXML::Document.new(xml_text).root
          title = Title.load_from_xml(xml)
          expect(title.lang).to eq('en')
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          title = Title.new(
            lang: 'en-emodeng',
            type: Types::TitleType::SUBTITLE,
            value: 'Together with an Appendix of the Same, Containing an Answer to Some Objections, Made by Severall Persons against That Hypothesis'
          )
          expected_xml = '<title xml:lang="en-emodeng" titleType="Subtitle">Together with an Appendix of the Same, Containing an Answer to Some Objections, Made by Severall Persons against That Hypothesis</title>'
          expect(title.save_to_xml).to be_xml(expected_xml)
        end
      end

    end

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
