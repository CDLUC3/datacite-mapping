require 'spec_helper'

module Datacite
  module Mapping

    describe GeoLocationPoint do
      describe '#initialize' do
        it 'accepts a lat/long pair' do
          point = GeoLocationPoint.new(47.61, -122.33)
          expect(point.latitude).to eq(47.61)
          expect(point.longitude).to eq(-122.33)
        end

        it 'accepts :latitude and :longitude' do
          point = GeoLocationPoint.new(latitude: 47.61, longitude: -122.33)
          expect(point.latitude).to eq(47.61)
          expect(point.longitude).to eq(-122.33)
        end

        it 'requires both latitude and longitude' do
          expect { GeoLocationPoint.new(47.61) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: 47.61) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(longitude: -122.33) }.to raise_error(ArgumentError)
        end

        it 'rejects extra array arguments' do
          expect { GeoLocationPoint.new(47.61, -122.33, -70.67) }.to raise_error(ArgumentError)
        end

        it 'rejects extra hash arguments' do
          expect { GeoLocationPoint.new(latitude: 47.61, longitude: -122.33, south_latitude: -70.67) }.to raise_error(ArgumentError)
        end

        it 'rejects bad values' do
          expect { GeoLocationPoint.new(91, -122.33) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(-91, -122.33) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(47.61, 181) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(47.61, -181) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: 91, longitude: -122.33) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: -91, longitude: -122.33) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: 47.61, longitude: 181) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: 47.61, longitude: -181) }.to raise_error(ArgumentError)
        end
      end

      describe '#latitude=' do
        it 'sets the latitude' do
          point = GeoLocationPoint.allocate
          point.latitude = 47.61
          expect(point.latitude).to eq(47.61)
        end
        it 'requires a value' do
          point = GeoLocationPoint.allocate
          expect { point.latitude = nil }.to raise_error(ArgumentError)
        end
        it 'rejects bad values' do
          point = GeoLocationPoint.allocate
          expect { point.latitude = 91 }.to raise_error(ArgumentError)
          expect { point.latitude = -91 }.to raise_error(ArgumentError)
        end
      end

      describe '#longitude=' do
        it 'sets the longitude' do
          point = GeoLocationPoint.allocate
          point.longitude = 47.61
          expect(point.longitude).to eq(47.61)
        end
        it 'requires a value' do
          point = GeoLocationPoint.allocate
          expect { point.longitude = nil }.to raise_error(ArgumentError)
        end
        it 'rejects bad values' do
          point = GeoLocationPoint.allocate
          expect { point.longitude = 181 }.to raise_error(ArgumentError)
          expect { point.longitude = -181 }.to raise_error(ArgumentError)
        end
      end
    end

    describe GeoLocationBox do
      describe '#initialize' do
        it 'accepts a lat/long/lat/long quad' do
          box = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          expect(box.south_latitude).to eq(-33.45)
          expect(box.west_longitude).to eq(-122.33)
          expect(box.north_latitude).to eq(47.61)
          expect(box.east_longitude).to eq(-70.67)
        end

        it 'accepts :south_latitude, :west_longitude, :north_latitude, :east_longitude' do
          box = GeoLocationBox.new(
            south_latitude: -33.45,
            west_longitude: -122.33,
            north_latitude: 47.61,
            east_longitude: -70.67
          )
          expect(box.south_latitude).to eq(-33.45)
          expect(box.west_longitude).to eq(-122.33)
          expect(box.north_latitude).to eq(47.61)
          expect(box.east_longitude).to eq(-70.67)
        end

        it 'requires all four coordinates with hash arguments' do
          all_args = {
            south_latitude: -33.45,
            west_longitude: -122.33,
            north_latitude: 47.61,
            east_longitude: -70.67
          }
          all_args.each_key do |k|
            bad_args = all_args.select { |k2, _v2| k2 == k }
            expect { GeoLocationBox.new(bad_args) }.to raise_error(ArgumentError)
          end
        end

        it 'requires all four coordinates with array arguments' do
          expect { GeoLocationBox.new(-33.45, -122.33, 47.61) }.to raise_error(ArgumentError)
        end

        it 'rejects extra array arguments' do
          expect { GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67, -33.45) }.to raise_error(ArgumentError)
        end

        it 'rejects extra hash arguments' do
          expect do
            GeoLocationBox.new(
              south_latitude: -33.45,
              west_longitude: -122.33,
              north_latitude: 47.61,
              east_longitude: -70.67,
              latitude: 47.61,
              longitude: -122.33
            )
          end.to raise_error(ArgumentError)
        end
      end

      describe '#south_latitude=' do
        it 'sets the south_latitude' do
          box = GeoLocationBox.allocate
          box.south_latitude = 47.61
          expect(box.south_latitude).to eq(47.61)
        end
        it 'requires a value' do
          box = GeoLocationBox.allocate
          expect { box.south_latitude = nil }.to raise_error(ArgumentError)
        end
        it 'rejects bad values' do
          box = GeoLocationBox.allocate
          expect { box.south_latitude = 91 }.to raise_error(ArgumentError)
          expect { box.south_latitude = -91 }.to raise_error(ArgumentError)
        end
      end

      describe '#west_longitude=' do
        it 'sets the west_longitude' do
          box = GeoLocationBox.allocate
          box.west_longitude = 47.61
          expect(box.west_longitude).to eq(47.61)
        end
        it 'requires a value' do
          box = GeoLocationBox.allocate
          expect { box.west_longitude = nil }.to raise_error(ArgumentError)
        end
        it 'rejects bad values' do
          box = GeoLocationBox.allocate
          expect { box.west_longitude = 181 }.to raise_error(ArgumentError)
          expect { box.west_longitude = -181 }.to raise_error(ArgumentError)
        end
      end

      describe '#north_latitude=' do
        it 'sets the north_latitude' do
          box = GeoLocationBox.allocate
          box.north_latitude = 47.61
          expect(box.north_latitude).to eq(47.61)
        end
        it 'requires a value' do
          box = GeoLocationBox.allocate
          expect { box.north_latitude = nil }.to raise_error(ArgumentError)
        end
        it 'rejects bad values' do
          box = GeoLocationBox.allocate
          expect { box.north_latitude = 91 }.to raise_error(ArgumentError)
          expect { box.north_latitude = -91 }.to raise_error(ArgumentError)
        end
      end

      describe '#east_longitude=' do
        it 'sets the east_longitude' do
          box = GeoLocationBox.allocate
          box.east_longitude = 47.61
          expect(box.east_longitude).to eq(47.61)
        end
        it 'requires a value' do
          box = GeoLocationBox.allocate
          expect { box.east_longitude = nil }.to raise_error(ArgumentError)
        end
        it 'rejects bad values' do
          box = GeoLocationBox.allocate
          expect { box.east_longitude = 181 }.to raise_error(ArgumentError)
          expect { box.east_longitude = -181 }.to raise_error(ArgumentError)
        end
      end
    end

    describe GeoLocation do
      describe '#initialize' do
        it 'accepts a point'
        it 'accepts a box'
        it 'accepts a place'
        it 'allows an empty location'
      end

      describe '#point=' do
        it 'sets the point'
        it 'accepts nil'
      end

      describe '#box=' do
        it 'sets the point'
        it 'accepts nil'
      end

      describe '#place=' do
        it 'sets the place'
        it 'accepts nil'
      end
    end
  end
end
