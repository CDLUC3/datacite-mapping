# coding: utf-8
require 'spec_helper'

module Datacite
  module Mapping
    describe Resource do

      attr_reader :args

      before(:each) do
        @args = {}
      end

      describe '#alternate_identifiers' do
        it 'defaults to empty' do
          resource = Resource.new(args)
          expect(resource.alternate_identifiers).to eq([])
        end

        it 'can be initialized' do
          alternate_identifiers = [
            AlternateIdentifier.new(type: 'URL', value: 'http://example.org'),
            AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
          ]
          args[:alternate_identifiers] = alternate_identifiers
          resource = Resource.new(args)
          expect(resource.alternate_identifiers).to eq(alternate_identifiers)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'can be set' do
          resource = Resource.new(args)
          alternate_identifiers = [
            AlternateIdentifier.new(type: 'URL', value: 'http://example.org'),
            AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
          ]
          resource.alternate_identifiers = alternate_identifiers
          expect(resource.alternate_identifiers).to eq(alternate_identifiers)
        end

      end

      describe 'DC3 support' do
        it 'reads a DC3 document'
        it 'reads a DC4 document'

        describe '#write_xml' do
          it 'sets the kernel-3 namespace'
          it 'writes a DC4 document as DC3'
          it 'warns about FundingReferences'
        end

        describe '#save_to_xml' do
          it 'sets the kernel-3 namespace'
          it 'writes a DC4 document as DC3'
          it 'warns about FundingReferences'
        end

        describe '#save_to_file' do
          it 'sets the kernel-3 namespace'
          it 'writes a DC4 document as DC3'
          it 'warns about FundingReferences'
        end
      end

      describe 'DC4 mapping' do
        it 'reads a DC4 document'
        it 'reads a DC3 document'

        describe '#write_xml' do
          it 'sets the kernel-4.0 namespace'
          it 'writes a DC3 document as DC4'
        end

        describe '#save_to_xml' do
          it 'sets the kernel-4.0 namespace'
          it 'writes a DC3 document as DC4'
        end

        describe '#save_to_file' do
          it 'sets the kernel-4.0 namespace'
          it 'writes a DC3 document as DC4'
        end
      end
    end
  end
end
