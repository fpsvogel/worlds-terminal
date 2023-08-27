require_relative 'entity'
require_relative 'components/component'
require_relative 'components/travel'
require_relative 'components/ticker'
require_relative 'area'

module Worlds
  class World
    attr_reader :areas

    class << self
      attr_reader :instance
    end

    def self.setup
      @instance = new
      @instance.demo_setup
    end

    def self.input(input)
      instance.input(input)
    end

    def self.update(ms)
      instance.update(ms)
    end

    def initialize
      @areas = []
    end

    def input(input)
      Entity.player.components.each do |component|
        if component.commands.include? input[:command]
          if input[:type] == :select
            selection_index = input[:selection] - 1

            if selection_index >= component.select_options.count
              return { color: :red, content: "Invalid selection" }
            end

            return component.invoke(selection_index)
          else
            return [component.select] || [component.invoke]
          end
        end
      end

      nil
    end

    def update(ms)
      outputs = []

      areas.each { |area|
        area_outputs = area.update(ms)
        outputs = area_outputs.compact if area == Entity.player.area
      }

      return outputs
    end

    def demo_setup
      hero = Entity.new
      hero.components << Components::Travel.new(hero, commands: %w[travel t go leave])
      Entity.player = hero

      clock = Entity.new
      clock.components << Components::Ticker.new(clock)

      street = Area.new("a quiet street")
      street.entities << hero

      shop = Area.new("Rolf's Clock Shop")
      shop.linked_areas << street
      shop.entities << clock
      street.linked_areas << shop

      @areas << street
      @areas << shop

      output = Entity.player.components.find { _1.is_a? Components::Travel }.invoke(street)

      [output]
    end
  end
end
