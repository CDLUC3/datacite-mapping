module Datacite
  module Mapping
    Dir.glob(File.expand_path('../mapping/*.rb', __FILE__)).sort.each(&method(:require))
  end
end
