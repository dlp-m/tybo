require "tybo/version"
require "tybo/engine"
require "tybo/configuration"

module Tybo
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
