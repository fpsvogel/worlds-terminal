module Worlds
  class Area
    attr_reader :name, :entities, :linked_areas

    def initialize(name)
      @name = name
      @entities = []
      @linked_areas = []
    end

    def update(ms)
      entities.flat_map { |entity|
        entity.update(ms)
      }
    end

    def to_s
      name
    end
  end
end
