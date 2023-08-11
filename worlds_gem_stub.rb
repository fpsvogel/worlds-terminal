class WorldsGemStub
  UPDATES_PER_SECOND = 1

  # Processes input if any, or performs an update if enough time has passed.
  # @param input [String] a line of input from the player.
  # @return [Array<Hash>, nil] an array of output hashes, if input was processed
  #   or an update was performed.
  def self.loop(input = nil)
    # On why not Time.now, see
    # https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way
    @time_start ||= Process.clock_gettime(Process::CLOCK_MONOTONIC)

    return process_input(input) if input

    time_now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    time_elapsed = time_now - @time_start

    if time_elapsed >= (1.0 / UPDATES_PER_SECOND)
      @time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      return update
    end
  end

  # Processes input and returns output in response.
  # @param input [String] a line of input from the player.
  # @return [Array<Hash>, nil] an array of output hashes.
  def self.process_input(input)
    outputs = []

    outputs << { color: :white, content: "You said: #{input}" }

    if input == 'exit'
      outputs << { color: :white, content: "Exiting..." }
      outputs << { special: :exit }
    end

    outputs
  end

  # Updates the world state and returns any resulting output.
  # @return [Array<Hash>, nil] an array of output hashes.
  def self.update
    outputs = []

    seconds = 1.0 / UPDATES_PER_SECOND.round(2)
    outputs << { color: :blue, content: "#{seconds} seconds have passed!" }

    outputs
  end
end
