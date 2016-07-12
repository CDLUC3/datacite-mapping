require 'logger'

module Datacite
  module Mapping
    # Nonvalidating types for non-strict parsing
    module Nonvalidating
      Dir.glob(File.expand_path('../nonvalidating/*.rb', __FILE__)).sort.each(&method(:require))
    end
  end
end
