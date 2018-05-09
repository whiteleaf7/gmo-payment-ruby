require "multi_json"
module Gmo
  module JSON

    def self.dump(*args)
      if MultiJson.respond_to?(:dump)
        MultiJson.dump(*args)
      else
        MultiJson.encode(*args)
      end
    end

  end
end
