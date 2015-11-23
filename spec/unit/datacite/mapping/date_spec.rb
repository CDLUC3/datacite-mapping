require 'spec_helper'

# Year:
#   YYYY (eg 1997)
# Year and month:
#   YYYY-MM (eg 1997-07)
# Complete date:
#   YYYY-MM-DD (eg 1997-07-16)
# Complete date plus hours and minutes:
#   YYYY-MM-DDThh:mmTZD (eg 1997-07-16T19:20+01:00)
# Complete date plus hours, minutes and seconds:
#   YYYY-MM-DDThh:mm:ssTZD (eg 1997-07-16T19:20:30+01:00)
# Complete date plus hours, minutes, seconds and a decimal fraction of a second
#   YYYY-MM-DDThh:mm:ss.sTZD (eg 1997-07-16T19:20:30.45+01:00)

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
        @dates = @values.map { |k, v| [k, Date.new(value: v)] }.to_h
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
      end

      describe 'value=' do
        it 'accepts a DateTime'
        it 'accepts a Date'
        it 'accepts a year as an integer'
        it 'accepts a year as a string'
        it 'accepts a year-month string'
        it 'accepts an ISO 8601 date string with hours and minutes'
        it 'accepts an ISO 8601 date string with hours, minutes, and seconds'
        it 'accepts an ISO 8601 date string with hours, minutes, seconds, and fractional seconds'
        it 'rejects invalid dates'
      end

      describe 'value' do
        it 'returns the value'
        it 'returns a string for a DateTime'
        it 'returns a string for a Date'
      end
      
      describe 'year' do
        it 'returns the year as an integer for a DateTime'
        it 'returns the year as an integer for a Date'
        it 'returns the year as an integer for a year as an integer'
        it 'returns the year as an integer for a year as a string'
        it 'returns the year as an integer for a year-month string'
        it 'returns the year as an integer for an ISO 8601 date string with hours and minutes'
        it 'returns the year as an integer for an ISO 8601 date string with hours, minutes, and seconds'
        it 'returns the year as an integer for an ISO 8601 date string with hours, minutes, seconds, and fractional seconds'
      end
      
      describe 'month' do
        it 'returns the month as an integer for a DateTime'
        it 'returns the month as an integer for a Date'
        it 'returns nil for a year as an integer'
        it 'returns nil for a year as a string'
        it 'returns the month as an integer for a year-month string'
        it 'returns the month as an integer for an ISO 8601 date string with hours and minutes'
        it 'returns the month as an integer for an ISO 8601 date string with hours, minutes, and seconds'
        it 'returns the month as an integer for an ISO 8601 date string with hours, minutes, seconds, and fractional seconds'
      end

      describe 'day' do
        it 'returns the day as an integer for a DateTime'
        it 'returns the day as an integer for a Date'
        it 'returns nil for a year as an integer'
        it 'returns nil for a year as a string'
        it 'returns nil for a year-month string'
        it 'returns the day as an integer for an ISO 8601 date string with hours and minutes'
        it 'returns the day as an integer for an ISO 8601 date string with hours, minutes, and seconds'
        it 'returns the day as an integer for an ISO 8601 date string with hours, minutes, seconds, and fractional seconds'
      end

      describe 'hour' do
        it 'returns the hour as an integer for a DateTime'
        it 'returns the hour as an integer for a Date'
        it 'returns nil for a year as an integer'
        it 'returns nil for a year as a string'
        it 'returns nil for a year-month string'
        it 'returns the hour as an integer for an ISO 8601 date string with hours and minutes'
        it 'returns the hour as an integer for an ISO 8601 date string with hours, minutes, and seconds'
        it 'returns the hour as an integer for an ISO 8601 date string with hours, minutes, seconds, and fractional seconds'
      end

      describe 'minutes' do
        it 'returns the minutes as an integer for a DateTime'
        it 'returns the minutes as an integer for a Date'
        it 'returns nil for a year as an integer'
        it 'returns nil for a year as a string'
        it 'returns nil for a year-month string'
        it 'returns the minutes as an integer for an ISO 8601 date string with hours and minutes'
        it 'returns the minutes as an integer for an ISO 8601 date string with hours, minutes, and seconds'
        it 'returns the minutes as an integer for an ISO 8601 date string with hours, minutes, seconds, and fractional seconds'
      end

      describe 'minutes' do
        it 'returns the seconds as an integer for a DateTime'
        it 'returns the seconds as an integer for a Date'
        it 'returns nil for a year as an integer'
        it 'returns nil for a year as a string'
        it 'returns nil for a year-month string'
        it 'returns nil for an ISO 8601 date string with hours and minutes'
        it 'returns the seconds as an integer for an ISO 8601 date string with hours, minutes, and seconds'
        it 'returns the seconds as a float for an ISO 8601 date string with hours, minutes, seconds, and fractional seconds'
      end
    end
  end
end
