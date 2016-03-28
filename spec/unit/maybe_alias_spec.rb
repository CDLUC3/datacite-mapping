require 'spec_helper'

class Foo
  include XML::Mapping

  def foo
    'foo'
  end

  @@result = maybe_alias :bar, :foo

  def self.result
    @@result
  end
end

module XML
  module Mapping
    module ClassMethods
      describe "#maybe_alias" do
        it 'aliases a method' do
          expect(Foo.result).to be(Foo)
          expect(Foo.new.bar).to eq('foo')
        end

        # we can't directly test that we're not double-aliasing,
        # but simplecov verifies that we're hitting the 'self' return
        # on the second invocation
        it "doesn't double-alias" do
          result = Foo.maybe_alias :bar, :foo
          expect(result).to be(Foo)
          expect(Foo.new.bar).to eq('foo')
        end
      end
    end
  end
end
