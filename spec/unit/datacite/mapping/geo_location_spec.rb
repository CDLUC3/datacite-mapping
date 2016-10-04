require 'spec_helper'

module Datacite
  module Mapping

    describe GeoLocation do

      attr_reader :warnings

      def warnings_including(substring)
        warnings.select { |w| w.include?(substring) }
      end

      def expect_warning(substring, count, include_matches = false)
        matches = warnings_including(substring)
        found_count = matches.size
        msg = "expected #{count} warnings including '#{substring}', found #{found_count}"
        msg << ": #{matches}" if include_matches
        expect(found_count).to eq(count), msg
      end

      before(:each) do
        @warnings = []
        allow(ReadOnlyNodes).to receive(:warn) do |w|
          warnings << w
          Kernel.warn(w) # for debugging
        end
      end

      describe '#initialize' do
        it 'accepts a point' do
          point = GeoLocationPoint.new(47.61, -122.33)
          loc = GeoLocation.new(point: point)
          expect(loc.point).to eq(point)
        end
        it 'accepts a box' do
          box = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          loc = GeoLocation.new(box: box)
          expect(loc.box).to eq(box)
        end
        it 'accepts a place' do
          place = 'Ouagadougou'
          loc = GeoLocation.new(place: place)
          expect(loc.place).to eq(place)
        end
        it 'accepts a polygon' do
          polygon = GeoLocationPolygon.new(points: [
            GeoLocationPoint.new(47.61, -122.33),
            GeoLocationPoint.new(-33.45, -122.33),
            GeoLocationPoint.new(47.61, -70.67),
            GeoLocationPoint.new(47.61, -122.33)
          ])
          loc = GeoLocation.new(polygon: polygon)
          expect(loc.polygon).to eq(polygon)
        end
        it 'allows an empty location' do
          loc = GeoLocation.new
          expect(loc.point).to be_nil
          expect(loc.box).to be_nil
          expect(loc.place).to be_nil
        end
      end

      describe '#point=' do
        it 'sets the point' do
          point = GeoLocationPoint.new(47.61, -122.33)
          loc = GeoLocation.new
          loc.point = point
          expect(loc.point).to eq(point)
        end
        it 'accepts nil' do
          loc = GeoLocation.new(point: GeoLocationPoint.new(47.61, -122.33))
          loc.point = nil
          expect(loc.point).to be_nil
        end
      end

      describe '#box=' do
        it 'sets the box' do
          box = GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67)
          loc = GeoLocation.new
          loc.box = box
          expect(loc.box).to eq(box)
        end
        it 'accepts nil' do
          loc = GeoLocation.new(box: GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67))
          loc.box = nil
          expect(loc.box).to be_nil
        end
      end

      describe '#place=' do
        it 'sets the place' do
          place = 'Ouagadougou'
          loc = GeoLocation.new
          loc.place = place
          expect(loc.place).to eq(place)
        end
        it 'accepts nil' do
          loc = GeoLocation.new(place: 'Ouagadougou')
          loc.place = nil
          expect(loc.place).to be_nil
        end
      end

      describe '#polygon=' do
        it 'sets the polygon' do
          polygon = GeoLocationPolygon.new(points: [
            GeoLocationPoint.new(47.61, -122.33),
            GeoLocationPoint.new(-33.45, -122.33),
            GeoLocationPoint.new(47.61, -70.67),
            GeoLocationPoint.new(47.61, -122.33)
          ])
          loc = GeoLocation.new
          loc.polygon = polygon
          expect(loc.polygon).to eq(polygon)
        end
      end

      describe '#load_from_xml' do
        it 'parses DC3' do
          xml_text = '<geoLocation>
                        <geoLocationPlace>Atlantic Ocean</geoLocationPlace>
                        <geoLocationPoint>31.233 -67.302</geoLocationPoint>
                        <geoLocationBox>41.090 -71.032 42.893 -68.211</geoLocationBox>
                      </geoLocation>'
          loc = GeoLocation.parse_xml(xml_text)
          expect(loc.point).to eq(GeoLocationPoint.new(31.233, -67.302))
          expect(loc.box).to eq(GeoLocationBox.new(41.09, -71.032, 42.893, -68.211))
          expect(loc.place).to eq('Atlantic Ocean')
        end

        it 'parses DC4' do
          xml_text = '<geoLocation>
                        <geoLocationPlace>Atlantic Ocean</geoLocationPlace>
                        <geoLocationPoint>
                          <pointLatitude>31.233</pointLatitude>
                          <pointLongitude>-67.302</pointLongitude>
                        </geoLocationPoint>
                        <geoLocationBox>
                          <southBoundLatitude>41.090</southBoundLatitude>
                          <westBoundLongitude>-71.032</westBoundLongitude>
                          <northBoundLatitude>42.893</northBoundLatitude>
                          <eastBoundLongitude>-68.211</eastBoundLongitude>
                        </geoLocationBox>
                        <geoLocationPolygon>
                          <polygonPoint>
                            <pointLongitude>-67.302</pointLongitude>
                            <pointLatitude>31.233</pointLatitude>
                          </polygonPoint>
                          <polygonPoint>
                            <pointLongitude>-71.032</pointLongitude>
                            <pointLatitude>-68.211</pointLatitude>
                          </polygonPoint>
                          <polygonPoint>
                            <pointLongitude>41.09</pointLongitude>
                            <pointLatitude>42.893</pointLatitude>
                          </polygonPoint>
                          <polygonPoint>
                            <pointLongitude>-67.302</pointLongitude>
                            <pointLatitude>31.233</pointLatitude>
                          </polygonPoint>
                        </geoLocationPolygon>
                      </geoLocation>'
          loc = GeoLocation.parse_xml(xml_text)
          expect(loc.point).to eq(GeoLocationPoint.new(31.233, -67.302))
          expect(loc.box).to eq(GeoLocationBox.new(41.09, -71.032, 42.893, -68.211))
          expect(loc.place).to eq('Atlantic Ocean')
          actual_polygon = loc.polygon
          expected_polygon = GeoLocationPolygon.new(points: [
            GeoLocationPoint.new(31.233, -67.302),
            GeoLocationPoint.new(-68.211, -71.032),
            GeoLocationPoint.new(42.893, 41.09),
            GeoLocationPoint.new(31.233, -67.302)
          ])
          expect(actual_polygon).to eq(expected_polygon)
        end

        it 'trims place-name whitespace' do
          xml_text = '<geoLocation>
                        <geoLocationPlace>
                          Atlantic Ocean
                        </geoLocationPlace>
                      </geoLocation>'
          loc = GeoLocation.parse_xml(xml_text)
          expect(loc.place).to eq('Atlantic Ocean')
        end
      end

      describe '#save_to_xml' do

        attr_reader :loc

        before(:each) do
          @loc = GeoLocation.new(
            point: GeoLocationPoint.new(31.233, -67.302),
            box: GeoLocationBox.new(41.09, -71.032, 42.893, -68.211),
            place: 'Atlantic Ocean',
            polygon: (GeoLocationPolygon.new(points: [
              GeoLocationPoint.new(-67.302, 31.233),
              GeoLocationPoint.new(-71.032, -68.211),
              GeoLocationPoint.new(41.09, 42.893),
              GeoLocationPoint.new(-67.302, 31.233)
            ]))
          )
        end

        describe 'DC4 mode' do
          it 'writes DC4' do
            expected_xml = '<geoLocation>
                              <geoLocationPlace>Atlantic Ocean</geoLocationPlace>
                              <geoLocationPoint>
                                <pointLatitude>31.233</pointLatitude>
                                <pointLongitude>-67.302</pointLongitude>
                              </geoLocationPoint>
                              <geoLocationBox>
                                <westBoundLongitude>-71.032</westBoundLongitude>
                                <eastBoundLongitude>-68.211</eastBoundLongitude>
                                <southBoundLatitude>41.09</southBoundLatitude>
                                <northBoundLatitude>42.893</northBoundLatitude>
                              </geoLocationBox>
                              <geoLocationPolygon>
                                <polygonPoint>
                                  <pointLongitude>31.233</pointLongitude>
                                  <pointLatitude>-67.302</pointLatitude>
                                </polygonPoint>
                                <polygonPoint>
                                  <pointLongitude>-68.211</pointLongitude>
                                  <pointLatitude>-71.032</pointLatitude>
                                </polygonPoint>
                                <polygonPoint>
                                  <pointLongitude>42.893</pointLongitude>
                                  <pointLatitude>41.09</pointLatitude>
                                </polygonPoint>
                                <polygonPoint>
                                  <pointLongitude>31.233</pointLongitude>
                                  <pointLatitude>-67.302</pointLatitude>
                                </polygonPoint>
                              </geoLocationPolygon>
                            </geoLocation>'
            actual_xml = loc.save_to_xml
            expect(actual_xml).to be_xml(expected_xml)
          end
        end

        describe 'DC3 mapping' do
          it 'writes DC3 points and boxes' do
            expected_xml = '<geoLocation>
                            <geoLocationPoint>31.233 -67.302</geoLocationPoint>
                            <geoLocationBox>41.09 -71.032 42.893 -68.211</geoLocationBox>
                            <geoLocationPlace>Atlantic Ocean</geoLocationPlace>
                          </geoLocation>'
            actual_xml = loc.save_to_xml(mapping: :datacite_3)
            expect(actual_xml).to be_xml(expected_xml)
            expect_warning(loc.polygon.to_s, 1)
          end

          it 'writes DC3 in XSD-defined order: point, box, place' do
            actual_xml = loc.save_to_xml(mapping: :datacite_3)
            expected_order = %w(geoLocationPoint geoLocationBox geoLocationPlace)
            actual_order = actual_xml.children.map(&:name)
            expect(actual_order).to eq(expected_order)
          end
        end
      end
    end
  end
end
