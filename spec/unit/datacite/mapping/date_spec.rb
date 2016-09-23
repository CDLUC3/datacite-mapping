require 'spec_helper'

module Datacite
  module Mapping
    describe Date do

      describe 'RKMS-ISO8601 support' do
        it 'supports closed datetime ranges' do
          date = Date.new(value: '1997-07-16T19:30+10:00/1997-07-17T15:30-05:00', type: DateType::VALID)
          expect(date.date_value).to be_nil
          expect(date.range_start).to eq(DateValue.new('1997-07-16T19:30+10:00'))
          expect(date.range_end).to eq(DateValue.new('1997-07-17T15:30-05:00'))
        end

        it 'supports left open datetime ranges' do
          date = Date.new(value: '/1997-07-17T15:30-05:00', type: DateType::VALID)
          expect(date.date_value).to be_nil
          expect(date.range_start).to be_nil
          expect(date.range_end).to eq(DateValue.new('1997-07-17T15:30-05:00'))
        end

        it 'supports right open datetime ranges' do
          date = Date.new(value: '1997-07-16T19:30+10:00/', type: DateType::VALID)
          expect(date.date_value).to be_nil
          expect(date.range_start).to eq(DateValue.new('1997-07-16T19:30+10:00'))
          expect(date.range_end).to be_nil
        end

        it 'fails on range-like non-ranges' do
          expect { Date.new(value: '5/18/72', type: DateType::VALID) }.to raise_error(ArgumentError)
        end
      end

      describe 'type=' do
        it 'sets the type' do
          d = Date.allocate
          d.type = DateType::COLLECTED
          expect(d.type).to eq(DateType::COLLECTED)
        end

        it 'rejects nil' do
          d = Date.new(value: 1914, type: DateType::COLLECTED)
          expect { d.type = nil }.to raise_error(ArgumentError)
          expect(d.type).to eq(DateType::COLLECTED)
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          d = Date.new(value: '1914-08-04T11:01:06.0123+01:00', type: DateType::AVAILABLE)
          expected_xml = '<date dateType="Available">1914-08-04T11:01:06.0123+01:00</date>'
          expect(d.save_to_xml).to be_xml(expected_xml)
        end
      end

      describe '#load_from_xml' do
        it 'reads XML' do
          xml = '<date dateType="Available">1914-08-04T11:01:06.0123+01:00</date>'
          d = Date.parse_xml(xml)
          expect(d.date_value).to eq(DateValue.new(DateTime.new(1914, 8, 4, 11, 0o1, 6.0123, '+1')))
        end
      end
    end
  end
end
