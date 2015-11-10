module Datacite
  module Mapping
    module Types
      Dir.glob(File.expand_path('../types/*.rb', __FILE__)).sort.each(&method(:require))
    end
  end
end
