require 'spec_helper'

module Datacite
  module Mapping
    describe Date do

      before(:each) do
        @values = {}
        @values[:with_date_time] = DateTime.new(1914, 8, 4, 11, 01, 6.0123, '+1')
        @values[:with_date] = ::Date.new(1914, 8, 4)
        @values[:with_year] = 1914
        @values[:with_year_str] = '1914'
        @values[:with_year_month] = '1914-08'
        @values[:iso8601] = '1914-08-04T11:01+01:00'
        @values[:iso8601_secs] = '1914-08-04T11:01:06+01:00'
        @values[:iso8601_frac] = '1914-08-04T11:01:06.0123+01:00'
        @dates = @values.map { |format, v| [format, Date.new(type: DateType::AVAILABLE, value: v)] }.to_h
      end

      describe '#initialize' do
        it 'accepts a DateTime' do
          d = @dates[:with_date_time]
          expect(d).to be_a(Date)
          expect(d.value).not_to be_nil
        end

        it 'accepts a Date' do
          d = @dates[:with_date]
          expect(d).to be_a(Date)
          expect(d.value).not_to be_nil
        end

        it 'accepts a year as an integer' do
          d = @dates[:with_year]
          expect(d).to be_a(Date)
          expect(d.value).not_to be_nil
        end

        it 'accepts a year as a string' do
          d = @dates[:with_year_str]
          expect(d).to be_a(Date)
          expect(d.value).not_to be_nil
        end

        it 'accepts a year-month string' do
          d = @dates[:with_year_month]
          expect(d).to be_a(Date)
          expect(d.value).not_to be_nil
        end

        it 'accepts an ISO 8601 date string with hours and minutes' do
          d = @dates[:iso8601]
          expect(d).to be_a(Date)
          expect(d.value).not_to be_nil
        end

        it 'accepts an ISO 8601 date string with hours, minutes, and seconds' do
          d = @dates[:iso8601_secs]
          expect(d).to be_a(Date)
          expect(d.value).not_to be_nil
        end

        it 'accepts an ISO 8601 date string with hours, minutes, seconds, and fractional seconds' do
          d = @dates[:iso8601_frac]
          expect(d).to be_a(Date)
          expect(d.value).not_to be_nil
        end

        it 'rejects invalid dates' do
          expect { Date.new(value: 'elvis') }.to raise_error(ArgumentError)
        end

        it 'rejects nil' do
          expect { Date.new(value: nil) }.to raise_error(ArgumentError)
        end
      end

      describe 'value=' do
        it 'accepts all date formats' do
          @values.each_value do |v|
            d = Date.allocate
            d.value = v
            expect(d.value).not_to be_nil, "Expected non-nil value for #{v}, got nil"
          end
        end

        it 'supports RKMS-ISO8601 date ranges'

        it 'rejects invalid dates' do
          d = Date.new(value: 1914, type: DateType::AVAILABLE)
          old_value = d.value
          expect { d.value = 'elvis' }.to raise_error(ArgumentError)
          expect(d.value).to eq(old_value)
        end

        it 'rejects nil' do
          d = Date.new(value: 1914, type: DateType::AVAILABLE)
          old_value = d.value
          expect { d.value = nil }.to raise_error(ArgumentError)
          expect(d.value).to eq(old_value)
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

      describe 'value' do
        it 'returns a string for a DateTime' do
          expect(@dates[:with_date_time].value).to eq(@values[:with_date_time].iso8601)
        end
        it 'returns a string for a Date' do
          expect(@dates[:with_date].value).to eq(@values[:with_date].iso8601)
        end
        it 'returns a string for a year as an integer' do
          expect(@dates[:with_year].value).to eq(@values[:with_year].to_s)
        end
        it 'returns a string for a year as a string' do
          expect(@dates[:with_year_str].value).to eq(@values[:with_year_str])
        end
        it 'returns a string for a year-month string' do
          expect(@dates[:with_year_month].value).to eq(@values[:with_year_month])
        end
        it 'preserves an ISO 8601 date string with hours and minutes' do
          expect(@dates[:iso8601].value).to eq(@values[:iso8601])
        end
        it 'preserves an ISO 8601 date string with hours, minutes, and seconds' do
          expect(@dates[:iso8601_secs].value).to eq(@values[:iso8601_secs])
        end
        it 'preserves an ISO 8601 date string with hours, minutes, seconds, and fractional seconds' do
          expect(@dates[:iso8601_frac].value).to eq(@values[:iso8601_frac])
        end
      end

      describe 'year' do
        it 'returns the year for all date formats' do
          @dates.each_value do |d|
            expect(d.year).to eq(1914)
          end
        end
      end

      describe 'month' do
        it 'returns the month for all date formats that have it' do
          expected = 8
          @dates.each_pair do |format, d|
            if [:with_year, :with_year_str].include?(format)
              expect(d.month).to be_nil
            else
              expect(d.month).to eq(expected), "expected #{expected}, got #{d.month} for :#{format} (#{d.value})"
            end
          end
        end
      end

      describe 'day' do
        it 'returns the day for all date formats that have it' do
          expected = 4
          @dates.each_pair do |format, d|
            if [:with_year, :with_year_str, :with_year_month].include?(format)
              expect(d.day).to be_nil
            else
              expect(d.day).to eq(expected), "expected #{expected}, got #{d.day} for :#{format} (#{d.value})"
            end
          end
        end
      end

      describe 'hour' do
        it 'returns the hour for all formats that have it' do
          expected = 11
          @dates.each_pair do |format, d|
            if [:with_date, :with_year, :with_year_str, :with_year_month].include?(format)
              expect(d.hour).to be_nil, "expected nil, got #{d.hour} for :#{format} (#{d.value})"
            else
              expect(d.hour).to eq(expected), "expected #{expected}, got #{d.hour} for :#{format} (#{d.value})"
            end
          end
        end
      end

      describe 'minute' do
        it 'returns the minutes for all formats that have it' do
          expected = 1
          @dates.each_pair do |format, d|
            if [:with_date, :with_year, :with_year_str, :with_year_month].include?(format)
              expect(d.minute).to be_nil, "expected nil, got #{d.hour} for :#{format} (#{d.value})"
            else
              expect(d.minute).to eq(expected), "expected #{expected}, got #{d.minute} for :#{format} (#{d.value})"
            end
          end
        end
      end

      describe 'sec' do
        it 'returns the seconds for all formats that have it' do
          expected = 6
          @dates.each_pair do |format, d|
            if [:with_date, :with_year, :with_year_str, :with_year_month].include?(format)
              expect(d.sec).to be_nil, "expected nil, got #{d.hour} for :#{format} (#{d.value})"
            elsif format == :iso8601
              expect(d.sec).to eq(0)
            else
              expect(d.sec).to eq(expected), "expected #{expected}, got #{d.sec} for :#{format} (#{d.value})"
            end
          end
        end
      end

      describe 'nsec' do
        it 'returns the nanoseconds for all formats that have it' do
          expected = 12_300_000
          @dates.each_pair do |format, d|
            if [:with_date, :with_year, :with_year_str, :with_year_month].include?(format)
              expect(d.nsec).to be_nil, "expected nil, got #{d.hour} for :#{format} (#{d.value})"
            elsif [:iso8601, :iso8601_secs].include?(format)
              expect(d.nsec).to eq(0)
            else
              expect(d.nsec).to eq(expected), "expected #{expected}, got #{d.nsec} for :#{format} (#{d.value})"
            end
          end
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          d = Date.new(value: '1914-08-04T11:01:06.0123+01:00', type: DateType::AVAILABLE)
          expected_xml = '<date dateType="Available">1914-08-04T11:01:06.0123+01:00</date>'
          expect(d.save_to_xml).to be_xml(expected_xml)
        end
      end

      describe '#load_from_xml'
    end
  end
end
