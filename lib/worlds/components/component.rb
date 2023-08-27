module Worlds
  module Components
    class Component
      attr_reader :owner
      attr_accessor :commands

      def initialize(entity, commands: [])
        @owner = entity
        @commands = commands
      end

      def select_heading
        "Select an option:"
      end

      def select_options
        []
      end

      def select
        return nil unless select_options.any?

        {
          type: :select,
          heading: select_heading,
          options: select_options.map(&:to_s),
        }
      end

      def invoke
      end

      def update(ms)
      end
    end
  end
end
