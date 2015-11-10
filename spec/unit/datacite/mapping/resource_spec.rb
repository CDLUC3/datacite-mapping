require 'spec_helper'

module Datacite
  module Mapping
    describe Resource do
      describe '#save_to_xml' do
        it 'sets the namespace to http://datacite.org/schema/kernel-3'
        it "doesn't clobber the namespace on the title xml:lang attribute"
      end
    end
  end
end
