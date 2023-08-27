module Worlds
  class SpecialCommands
    ACTIONS = {
      exit: -> {
        [{ color: :white, content: "Exiting..." },
          { type: :exit }]
      },
    }
  end
end
