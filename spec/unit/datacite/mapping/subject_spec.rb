require 'spec_helper'

module Datacite
  module Mapping
    describe Subject do
      describe '#initialize' do
        it 'sets the value'
        it 'sets the language'  # cf. Title
        it 'sets the scheme'    # cf. NameIdentifier
        it 'sets the schemeURI' # cf. NameIdentifier
        it 'defaults to a nil scheme'
        it 'defaults to a nil schemeURI'
        it 'requires a language'
      end

      describe 'lang=' do
        it 'requires a language'
      end

      describe '#load_from_xml' do
        it 'parses XML'
        it 'treats missing language as en-us'
      end

      describe '#save_to_xml' do
        it 'writes XML'
      end
    end

    describe Subjects do
      it 'round-trips to XML'
    end
  end
end
