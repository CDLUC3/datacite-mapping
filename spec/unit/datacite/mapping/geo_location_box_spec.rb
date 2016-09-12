require 'spec_helper'

module Datacite
  module Mapping
    describe GeoLocationBox do
      describe '#initialize' do
        it 'accepts a lat/long/lat/long quad' do
          box = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          expect(box.south_latitude).to eq(-33.45)
          expect(box.west_longitude).to eq(-122.33)
          expect(box.north_latitude).to eq(47.61)
          expect(box.east_longitude).to eq(-70.67)
        end

        it 'accepts a quad with flipped east/west coordinates' do
          box = GeoLocationBox.new(-33.45, -70.67, 47.61, -122.33)
          expect(box.south_latitude).to eq(-33.45)
          expect(box.west_longitude).to eq(-122.33)
          expect(box.north_latitude).to eq(47.61)
          expect(box.east_longitude).to eq(-70.67)
        end

        it 'accepts a quad with flipped north/south coordinates' do
          box = GeoLocationBox.new(47.61, -122.33, -33.45, -70.67)
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

      describe '#==' do
        it 'reports equal values as equal' do
          box1 = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          box2 = GeoLocationBox.new(
            south_latitude: -33.45,
            west_longitude: -122.33,
            north_latitude: 47.61,
            east_longitude: -70.67
          )
          expect(box1).to eq(box2)
          expect(box2).to eq(box1)
        end
        it 'reports unequal values as unequal' do
          box1 = GeoLocationBox.new(-47.61, -70.67, -33.45, 122.33)
          box2 = GeoLocationBox.new(
            south_latitude: -33.45,
            west_longitude: -122.33,
            north_latitude: 47.61,
            east_longitude: -70.67
          )
          expect(box1).not_to eq(box2)
          expect(box2).not_to eq(box1)
        end
      end

      describe '#hash' do
        it 'reports equal values as having equal hashes' do
          box1 = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          box2 = GeoLocationBox.new(
            south_latitude: -33.45,
            west_longitude: -122.33,
            north_latitude: 47.61,
            east_longitude: -70.67
          )
          expect(box1.hash).to eq(box2.hash)
          expect(box2.hash).to eq(box1.hash)
        end
        it 'reports unequal values as having unequal hashes' do
          box1 = GeoLocationBox.new(-47.61, -70.67, -33.45, 122.33)
          box2 = GeoLocationBox.new(
            south_latitude: -33.45,
            west_longitude: -122.33,
            north_latitude: 47.61,
            east_longitude: -70.67
          )
          expect(box1.hash).not_to eq(box2.hash)
          expect(box2.hash).not_to eq(box1.hash)
        end
      end

      describe '#to_s' do
        it 'returns the coordinates' do
          box = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          expect(box.to_s).to eq('-33.45 -122.33 47.61 -70.67')
        end
      end
    end

    describe GeoLocationBoxNode do

      class SomeElement
        include XML::Mapping
      end

      describe '#to_value' do
        it 'parses the value' do
          xml_text = '-33.45 -122.33 47.61 -70.67'
          node = GeoLocationBoxNode.new(SomeElement, :box, 'box')
          expected_box = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          expect(node.to_value(xml_text)).to eq(expected_box)
        end
        it 'deals with flipped east/west coordinates' do
          xml_text = '-33.45 -70.67 47.61 -122.33'
          node = GeoLocationBoxNode.new(SomeElement, :box, 'box')
          expected_box = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          expect(node.to_value(xml_text)).to eq(expected_box)
        end
        it 'deals with flipped north/south coordinates' do
          xml_text = '47.61 -122.33 -33.45 -70.67'
          node = GeoLocationBoxNode.new(SomeElement, :box, 'box')
          expected_box = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          expect(node.to_value(xml_text)).to eq(expected_box)
        end
        it 'deals with weird whitespace' do
          node = GeoLocationBoxNode.new(SomeElement, :box, 'box')
          xml_text = %(
                        -33.45 -122.33\t47.61 -70.67
                     )
          expected = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          expect(node.to_value(xml_text)).to eq(expected)
        end
      end

      describe 'DC4 lat/long tags' do
        describe 'DC4 mode' do
          it 'parses a DC4 box' do
            xml_text = File.read('spec/data/datacite4/datacite-example-Box_dateCollected_DataCollector-v4.0.xml')
            resource = Resource.parse_xml(xml_text)
            locs = resource.geo_locations
            expect(locs.size).to eq(1)
            loc = locs[0]
            box = loc.box
            expect(box).to be_a(GeoLocationBox)
            expect(box.west_longitude).to eq(-64.2)
            expect(box.east_longitude).to eq(-63.8)
            expect(box.south_latitude).to eq(44.7167)
            expect(box.north_latitude).to eq(44.9667)
          end

          it 'writes a DC4 box'
        end

        describe 'DC3 mode' do
          it 'writes DC4 boxes as DC3'
        end
      end
    end
  end
end
