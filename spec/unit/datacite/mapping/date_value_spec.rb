require 'spec_helper'

module Datacite
  module Mapping
    describe DateValue do

      attr_reader :values
      attr_reader :dates

      before(:all) do
        @values = {
          with_date_time: DateTime.new(1914, 8, 4, 11, 1, 6.0123, '+1'),
          with_date: ::Date.new(1914, 8, 4),
          with_year: 1914,
          with_year_str: '1914',
          with_year_month: '1914-08',
          iso8601: '1914-08-04T11:01+01:00',
          iso8601_secs: '1914-08-04T11:01:06+01:00',
          iso8601_frac: '1914-08-04T11:01:06.0123+01:00'
        }
        @dates = values.map { |format, v| [format, DateValue.new(v)] }.to_h
      end

      describe '#initialize' do
        it 'accepts a DateTime' do
          d = dates[:with_date_time]
          expect(d).to be_a(DateValue)
          expect(d.year).to eq(1914)
          expect(d.month).to eq(8)
          expect(d.day).to eq(4)
          expect(d.date).to eq(::Date.new(1914, 8, 4))
          expect(d.hour).to eq(11)
          expect(d.minute).to eq(1)
          expect(d.sec).to eq(6)
          expect(d.nsec).to eq(12_300_000)
        end

        it 'accepts a DateValue' do
          d = dates[:with_date]
          expect(d).to be_a(DateValue)
          expect(d.year).to eq(1914)
          expect(d.month).to eq(8)
          expect(d.day).to eq(4)
          expect(d.date).to eq(::Date.new(1914, 8, 4))
        end

        it 'accepts a year as an integer' do
          d = dates[:with_year]
          expect(d).to be_a(DateValue)
          expect(d.year).to eq(1914)
        end

        it 'accepts a year as a string' do
          d = dates[:with_year_str]
          expect(d).to be_a(DateValue)
          expect(d.year).to eq(1914)
        end

        it 'accepts a year-month string' do
          d = dates[:with_year_month]
          expect(d).to be_a(DateValue)
          expect(d.year).to eq(1914)
          expect(d.month).to eq(8)
        end

        it 'accepts an ISO 8601 DateValue string with hours and minutes' do
          d = dates[:iso8601]
          expect(d).to be_a(DateValue)
          expect(d.year).to eq(1914)
          expect(d.month).to eq(8)
          expect(d.day).to eq(4)
          expect(d.date).to eq(::Date.new(1914, 8, 4))
          expect(d.hour).to eq(11)
          expect(d.minute).to eq(1)
        end

        it 'accepts an ISO 8601 DateValue string with hours, minutes, and seconds' do
          d = dates[:iso8601_secs]
          expect(d).to be_a(DateValue)
          expect(d.year).to eq(1914)
          expect(d.month).to eq(8)
          expect(d.day).to eq(4)
          expect(d.date).to eq(::Date.new(1914, 8, 4))
          expect(d.hour).to eq(11)
          expect(d.minute).to eq(1)
          expect(d.sec).to eq(6)
        end

        it 'accepts an ISO 8601 DateValue string with hours, minutes, seconds, and fractional seconds' do
          d = dates[:iso8601_frac]
          expect(d).to be_a(DateValue)
          expect(d.year).to eq(1914)
          expect(d.month).to eq(8)
          expect(d.day).to eq(4)
          expect(d.date).to eq(::Date.new(1914, 8, 4))
          expect(d.hour).to eq(11)
          expect(d.minute).to eq(1)
          expect(d.sec).to eq(6)
          expect(d.nsec).to eq(12_300_000)
        end

        it 'rejects invalid dates' do
          expect { DateValue.new(value: 'elvis') }.to raise_error(ArgumentError)
        end

        it 'rejects nil' do
          expect { DateValue.new(value: nil) }.to raise_error(ArgumentError)
        end
      end

      describe '#<=>' do
        it 'reports equal values as equal' do
          d1 = DateValue.new(DateTime.new(1914, 8, 4, 11, 0o1, 6.0123, '+1'))
          d2 = DateValue.new(DateTime.new(1914, 8, 4, 11, 0o1, 6.0123, '+1'))
          expect(d1).to eq(d2)
          expect(d1.hash).to eq(d2.hash)
        end

        it 'reports equal values initialized differently as equal' do
          d1 = DateValue.new('1914-08-04T11:01:06.0123+01:00')
          d2 = DateValue.new(DateTime.new(1914, 8, 4, 11, 0o1, 6.0123, '+1'))
          expect(d1).to eq(d2)
          expect(d1.hash).to eq(d2.hash)
        end

        it 'reports unequal values as unequal' do
          d1 = DateValue.new('1914-08-04T11:01+01:00')
          d2 = DateValue.new(DateTime.new(1914, 8, 4, 11, 0o1, 6.0123, '+1'))
          expect(d1).not_to eq(d2)
          expect(d1.hash).not_to eq(d2.hash)
        end
      end

      describe '#to_s' do
        it 'returns an ISO-8601 string for all formats' do
          expected = {
            with_date_time: '1914-08-04T11:01:06.0123+01:00',
            with_date: '1914-08-04',
            with_year: '1914',
            with_year_str: '1914',
            with_year_month: '1914-08',
            iso8601: '1914-08-04T11:01+01:00',
            iso8601_secs: '1914-08-04T11:01:06+01:00',
            iso8601_frac: '1914-08-04T11:01:06.0123+01:00'
          }
          dates.each do |format, v|
            actual_str = v.to_s
            expected_str = expected[format]
            expect(actual_str).to eq(expected_str), "expected '#{expected_str}' for #{format}, got '#{actual_str}'"
          end
        end
      end
    end
  end
end
