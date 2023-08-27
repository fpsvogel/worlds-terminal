require_relative 'special_commands'
require_relative 'world'

module Worlds
  # A container for ::tick, which processes input and updates the world state.
  class Updater
    UPDATES_PER_SECOND = 1

    # Whether the world has been started.
    # @return [Boolean]
    def self.started?
      !!@time_start
    end

    # Processes input if any, or performs an update if enough time has passed.
    # @param input [Hash] a line of input from the player.
    # @return [Array<Hash>, nil] an array of output hashes, if input was processed
    #   or an update was performed.
    def self.tick(input = nil)
      unless started?
        # On why not Time.now, see
        # https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way
        @time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        return World.setup
      end

      return process_input(input) if input

      time_now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      time_elapsed = time_now - @time_start

      if time_elapsed >= (1.0 / UPDATES_PER_SECOND)
        @time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        return update
      end
    end

    # Processes input and returns output in response.
    # @param input [Hash] a line of input from the player.
    # @return [Array<Hash>, nil] an array of output hashes.
    private_class_method def self.process_input(input)
      outputs = []

      if action = SpecialCommands::ACTIONS[input[:command].to_sym]
        outputs += action.call
      else
        outputs += [World.input(input)].flatten.compact
      end

      if outputs.empty?
        outputs << { color: :red, content: "Invalid command: #{input[:command]}" }
      end

      outputs
    end

    # Updates the world state and returns any resulting output.
    # @return [Array<Hash>, nil] an array of output hashes.
    private_class_method def self.update
      outputs = []

      ms = 1000 / UPDATES_PER_SECOND.round(2)
      outputs += World.update(ms)

      outputs
    end
  end
end
