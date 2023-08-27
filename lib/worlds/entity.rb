module Worlds
  class Entity
    attr_reader :components
    attr_accessor :area

    class << self
      attr_accessor :player
    end

    def initialize
      @components = []
    end

    def update(ms)
      components.flat_map { |component|
        component.update(ms)
      }
    end
  end
end
