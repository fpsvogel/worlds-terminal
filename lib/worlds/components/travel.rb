module Worlds
  module Components
    class Travel < Component
      def select_heading
        "Choose a destination:"
      end

      def select_options
        owner.area.linked_areas
      end

      # @param target [Area, Integer] an Area, or the index of an Area in the
      #   owner's linked areas.
      def invoke(target)
        target = target.is_a?(Area) ? target : owner.area.linked_areas[target]

        owner.area&.entities&.delete(owner)
        target.entities << owner
        owner.area = target

        { color: :green, content: "You are now in #{target.name}" }
      end
    end
  end
end
